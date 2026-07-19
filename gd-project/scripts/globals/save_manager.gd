extends Node

# Autoload save system. A run always resumes at the beginning of the saved
# quota. Progress earned during an unfinished clicking phase is not restored.

const SAVE_PATH := "user://savegame.json"
const SAVE_VERSION := 5
const MAIN_MENU_PATH := "res://scenes/ui/mainmenu.tscn"

signal game_saved
signal game_loaded

var _click_upgrade_data: ClickUpgradeData = null
var _pending_upgrades: Variant = null

var _factory_manager: FactoryManager = null
var _pending_factories: Array = []
var _is_applying_factories: bool = false

var _shop: Shop = null
var _crowbar_purchased: bool = false

var _checkpoint_score: int = 0
var _intro_played: bool = false
var _broken_board_ids: Array[String] = []


func _ready() -> void:
	if not QuotaManager.preparation_phase_started.is_connected(save_game):
		QuotaManager.preparation_phase_started.connect(save_game)

	get_tree().set_auto_accept_quit(false)
	if not get_tree().node_added.is_connected(_on_tree_node_added):
		get_tree().node_added.connect(_on_tree_node_added)


func _notification(what: int) -> void:
	if what != NOTIFICATION_WM_CLOSE_REQUEST:
		return

	# Entering the main menu already creates a save. Saving again from the menu
	# would overwrite it with reset runtime values and no scene-local managers.
	if not _is_main_menu_open():
		save_game()

	get_tree().quit()


func _is_main_menu_open() -> bool:
	var current_scene := get_tree().current_scene
	return (
		current_scene != null
		and current_scene.scene_file_path == MAIN_MENU_PATH
	)


func register_click_upgrade_data(data: ClickUpgradeData) -> void:
	_click_upgrade_data = data
	if _pending_upgrades != null:
		var pending: Dictionary = _pending_upgrades
		_apply_upgrades(pending)
		_pending_upgrades = null


func register_shop(shop: Shop) -> void:
	if shop == null or not is_instance_valid(shop):
		return
	_shop = shop
	_shop.restore_crowbar_purchase(_crowbar_purchased)


func register_factory_manager(manager: FactoryManager) -> void:
	if manager == null or not is_instance_valid(manager):
		return
	if (
		_factory_manager == manager
		and manager.factory_updated.is_connected(_on_factory_updated)
	):
		return

	if (
		_has_live_factory_manager()
		and _factory_manager != manager
		and _factory_manager.factory_updated.is_connected(_on_factory_updated)
	):
		_factory_manager.factory_updated.disconnect(_on_factory_updated)

	_factory_manager = manager
	if not _pending_factories.is_empty():
		_apply_factories(_pending_factories)

	if not manager.factory_updated.is_connected(_on_factory_updated):
		manager.factory_updated.connect(_on_factory_updated)

	print(
		"SaveManager: registered %d factories."
		% manager.get_all_factories().size()
	)


func _on_tree_node_added(node: Node) -> void:
	if node is FactoryManager:
		call_deferred("_register_factory_manager_deferred", node)


func _register_factory_manager_deferred(node: Node) -> void:
	if (
		not is_instance_valid(node)
		or not node.is_inside_tree()
		or node is not FactoryManager
	):
		return
	register_factory_manager(node as FactoryManager)


func _on_factory_updated(_factory: Factory) -> void:
	if _is_applying_factories:
		return
	# Synchronous writing prevents a deferred save from running after the menu
	# handler has reset the in-memory quota.
	save_game()


func save_game() -> bool:
	# During preparation this is the balance earned after the last successful
	# quota. During RUNNING keep the old value, so unfinished clicks disappear.
	if QuotaManager.current_state != QuotaManager.GameState.RUNNING:
		_checkpoint_score = maxi(0, GameManager.score)

	var factories := _serialize_factories()
	_pending_factories = factories.duplicate(true)

	if _has_live_shop():
		_crowbar_purchased = _shop.is_crowbar_purchased()

	var data := {
		"version": SAVE_VERSION,
		"has_started": true,
		"timestamp": Time.get_unix_time_from_system(),
		"quota_index": QuotaManager.current_quota_index,
		"checkpoint_score": _checkpoint_score,
		"tickets": GameManager.tickets,
		"additive_bonuses": GameManager._additive_bonuses,
		"multiplicative_bonuses": GameManager._multiplicative_bonuses,
		"upgrades": _serialize_upgrades(),
		"factories": factories,
		"crowbar_purchased": _crowbar_purchased,
		"intro_played": _intro_played,
		"broken_board_ids": _broken_board_ids,
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error(
			"SaveManager: cannot open save file: %s"
			% FileAccess.get_open_error()
		)
		return false

	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	game_saved.emit()
	print(
		"SaveManager: saved quota %d, score %d and %d factories."
		% [data["quota_index"], _checkpoint_score, factories.size()]
	)
	return true


func save_before_return_to_menu() -> bool:
	return save_game()


func load_game() -> bool:
	var parsed := _read_save_file()
	if parsed.is_empty():
		return false

	QuotaManager.current_quota_index = clampi(
		int(parsed.get("quota_index", 0)),
		0,
		maxi(QuotaManager.quotas.size() - 1, 0)
	)
	QuotaManager.current_state = QuotaManager.GameState.IDLE
	QuotaManager.time_left = 0.0
	QuotaManager.current_quota_target = 0

	_checkpoint_score = maxi(0, int(parsed.get("checkpoint_score", 0)))
	GameManager.score = _checkpoint_score

	GameManager.tickets = maxi(0, int(parsed.get("tickets", 0)))
	GameManager.tickets_changed.emit(GameManager.tickets)

	GameManager._additive_bonuses.clear()
	var additive_value: Variant = parsed.get("additive_bonuses", [])
	if typeof(additive_value) == TYPE_ARRAY:
		for bonus in additive_value:
			GameManager._additive_bonuses.append(int(bonus))

	GameManager._multiplicative_bonuses.clear()
	var multiplicative_value: Variant = parsed.get(
		"multiplicative_bonuses",
		[]
	)
	if typeof(multiplicative_value) == TYPE_ARRAY:
		for factor in multiplicative_value:
			GameManager._multiplicative_bonuses.append(float(factor))
	GameManager._recalculate_click_power()
	GameManager.notify_score_reservation_changed()

	var upgrades_value: Variant = parsed.get("upgrades", {})
	if typeof(upgrades_value) != TYPE_DICTIONARY:
		upgrades_value = {}
	var upgrades: Dictionary = upgrades_value
	_pending_upgrades = upgrades.duplicate(true)
	if _click_upgrade_data != null:
		_apply_upgrades(upgrades)
		_pending_upgrades = null

	var factories_value: Variant = parsed.get("factories", [])
	if typeof(factories_value) != TYPE_ARRAY:
		factories_value = []
	var factories: Array = factories_value
	_pending_factories = factories.duplicate(true)
	if _has_live_factory_manager():
		_apply_factories(_pending_factories)

	_crowbar_purchased = bool(parsed.get("crowbar_purchased", false))
	if _has_live_shop():
		_shop.restore_crowbar_purchase(_crowbar_purchased)

	_intro_played = bool(parsed.get("intro_played", true))
	_broken_board_ids.clear()
	var boards_value: Variant = parsed.get("broken_board_ids", [])
	if typeof(boards_value) == TYPE_ARRAY:
		for value in boards_value:
			var board_id := String(value)
			if not board_id.is_empty() and board_id not in _broken_board_ids:
				_broken_board_ids.append(board_id)

	game_loaded.emit()
	print(
		"SaveManager: loaded quota %d, score %d and %d factory records."
		% [
			QuotaManager.current_quota_index,
			_checkpoint_score,
			_pending_factories.size(),
		]
	)
	return true


func has_save() -> bool:
	return not _read_save_file().is_empty()


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)


func reset_progress() -> void:
	delete_save()
	_pending_upgrades = null
	_pending_factories.clear()
	_checkpoint_score = 0
	_crowbar_purchased = false
	_intro_played = false
	_broken_board_ids.clear()

	if _click_upgrade_data != null:
		_click_upgrade_data.add_level = 0
		_click_upgrade_data.mult_level = 0
		_click_upgrade_data.percent_level = 0
		_click_upgrade_data.crit_level = 0
		_click_upgrade_data.total_clicks = 0

	if _has_live_shop():
		_shop.restore_crowbar_purchase(false)

	GameManager._additive_bonuses.clear()
	GameManager._multiplicative_bonuses.clear()
	GameManager._recalculate_click_power()

	if _has_live_factory_manager():
		_reset_factories_to_templates()


func save_after_death() -> bool:
	QuotaManager.current_quota_index = 0
	QuotaManager.current_state = QuotaManager.GameState.IDLE
	QuotaManager.time_left = 0.0
	QuotaManager.current_quota_target = 0
	GameManager.score = 0
	_checkpoint_score = 0
	return save_game()


func has_intro_played() -> bool:
	return _intro_played


func mark_intro_played() -> void:
	if _intro_played:
		return
	_intro_played = true
	save_game()


func is_board_broken(board_id: String) -> bool:
	return board_id in _broken_board_ids


func mark_board_broken(board_id: String) -> void:
	if board_id.is_empty() or board_id in _broken_board_ids:
		return
	_broken_board_ids.append(board_id)
	save_game()


func _serialize_upgrades() -> Dictionary:
	if _click_upgrade_data == null:
		if typeof(_pending_upgrades) == TYPE_DICTIONARY:
			return _pending_upgrades.duplicate(true)
		return {}

	return {
		"add_level": _click_upgrade_data.add_level,
		"mult_level": _click_upgrade_data.mult_level,
		"percent_level": _click_upgrade_data.percent_level,
		"crit_level": _click_upgrade_data.crit_level,
		"total_clicks": _click_upgrade_data.total_clicks,
	}


func _apply_upgrades(upgrades: Dictionary) -> void:
	if _click_upgrade_data == null:
		return
	_click_upgrade_data.add_level = maxi(0, int(upgrades.get("add_level", 0)))
	_click_upgrade_data.mult_level = maxi(0, int(upgrades.get("mult_level", 0)))
	_click_upgrade_data.percent_level = maxi(
		0,
		int(upgrades.get("percent_level", 0))
	)
	_click_upgrade_data.crit_level = maxi(0, int(upgrades.get("crit_level", 0)))
	_click_upgrade_data.total_clicks = maxi(
		0,
		int(upgrades.get("total_clicks", 0))
	)


func _serialize_factories() -> Array:
	if not _has_live_factory_manager():
		return _pending_factories.duplicate(true)

	var result: Array = []
	var factories := _factory_manager.get_all_factories()
	for index in range(factories.size()):
		var factory: Factory = factories[index]
		if factory == null or factory.data == null:
			continue
		if not factory.data.is_purchased:
			continue

		var data: AutoClickerData = factory.data
		var template_path := ""
		if factory.template_data != null:
			template_path = factory.template_data.resource_path

		result.append({
			"index": index,
			"template_path": template_path,
			"is_purchased": true,
			"click_value": data.click_value,
			"click_ticks_period": data.click_ticks_period,
			"cur_click_ticks": data.cur_click_ticks,
			"max_hp": data.max_hp,
			"cur_hp": data.cur_hp,
			"rhpt": data.rhpt,
			"dmg": data.dmg,
			"dps": data.dps,
			"base_dps": data.base_dps,
			"dmg_tick_period": data.dmg_tick_period,
			"cur_tick_dmg": data.cur_tick_dmg,
			"is_factory_pause": data.is_factory_pause,
			"upg_lvl_hp": data.upg_lvl_hp,
			"upg_lvl_click": data.upg_lvl_click,
			"upg_lvl_dmg": data.upg_lvl_dmg,
			"upg_lvl_dmg_period": data.upg_lvl_dmg_period,
			"upg_lvl_rhpt": data.upg_lvl_rhpt,
			"cur_price_hp": data.cur_price_hp,
			"cur_price_click": data.cur_price_click,
			"cur_price_dmg": data.cur_price_dmg,
			"cur_price_dmg_period": data.cur_price_dmg_period,
			"cur_price_rhpt": data.cur_price_rhpt,
		})
	return result


func _apply_factories(saved_factories: Array) -> void:
	if not _has_live_factory_manager():
		_pending_factories = saved_factories.duplicate(true)
		return

	_is_applying_factories = true
	_reset_factories_to_templates()

	for saved_value in saved_factories:
		if typeof(saved_value) != TYPE_DICTIONARY:
			continue
		var saved: Dictionary = saved_value
		var index := int(saved.get("index", -1))
		var factory := _find_factory_for_save(index, saved)
		if factory == null or factory.data == null:
			continue

		var data: AutoClickerData = factory.data
		data.is_purchased = bool(
			saved.get("is_purchased", saved.get("purchased", true))
		)
		data.click_value = maxi(1, int(saved.get("click_value", data.click_value)))
		data.click_ticks_period = maxi(
			1,
			int(saved.get("click_ticks_period", data.click_ticks_period))
		)
		data.cur_click_ticks = maxi(0, int(saved.get("cur_click_ticks", 0)))
		data.max_hp = maxi(1, int(saved.get("max_hp", data.max_hp)))
		data.cur_hp = clampi(int(saved.get("cur_hp", data.max_hp)), 0, data.max_hp)
		data.rhpt = maxi(0, int(saved.get("rhpt", data.rhpt)))
		data.dmg = maxi(1, int(saved.get("dmg", data.dmg)))
		data.dps = maxf(0.0, float(saved.get("dps", data.dps)))
		data.base_dps = maxf(0.0, float(saved.get("base_dps", data.base_dps)))
		data.dmg_tick_period = maxi(
			1,
			int(saved.get("dmg_tick_period", data.dmg_tick_period))
		)
		data.cur_tick_dmg = maxi(0, int(saved.get("cur_tick_dmg", 0)))
		data.is_factory_pause = bool(saved.get("is_factory_pause", false))
		data.upg_lvl_hp = maxi(0, int(saved.get("upg_lvl_hp", 0)))
		data.upg_lvl_click = maxi(0, int(saved.get("upg_lvl_click", 0)))
		data.upg_lvl_dmg = maxi(0, int(saved.get("upg_lvl_dmg", 0)))
		data.upg_lvl_dmg_period = maxi(
			0,
			int(saved.get("upg_lvl_dmg_period", 0))
		)
		data.upg_lvl_rhpt = maxi(0, int(saved.get("upg_lvl_rhpt", 0)))
		data.cur_price_hp = maxi(0, int(saved.get("cur_price_hp", data.cur_price_hp)))
		data.cur_price_click = maxi(
			0,
			int(saved.get("cur_price_click", data.cur_price_click))
		)
		data.cur_price_dmg = maxi(0, int(saved.get("cur_price_dmg", data.cur_price_dmg)))
		data.cur_price_dmg_period = maxi(
			0,
			int(saved.get("cur_price_dmg_period", data.cur_price_dmg_period))
		)
		data.cur_price_rhpt = maxi(
			0,
			int(saved.get("cur_price_rhpt", data.cur_price_rhpt))
		)

		data.normalize_dps(_factory_manager.tick_interval)
		if data.is_purchased and factory not in _factory_manager.active_factories:
			_factory_manager.active_factories.append(factory)
		factory._update_ui()

	_factory_manager._emit_cps_if_changed(true)
	_is_applying_factories = false
	print(
		"SaveManager: restored %d factory records."
		% saved_factories.size()
	)


func _find_factory_for_save(index: int, saved: Dictionary) -> Factory:
	var factories := _factory_manager.get_all_factories()
	if index >= 0 and index < factories.size():
		return factories[index]

	var saved_path := String(
		saved.get("template_path", saved.get("id", ""))
	)
	if saved_path.is_empty():
		return null
	for factory: Factory in factories:
		if (
			factory != null
			and factory.template_data != null
			and factory.template_data.resource_path == saved_path
		):
			return factory
	return null


func _reset_factories_to_templates() -> void:
	if not _has_live_factory_manager():
		return
	_factory_manager.active_factories.clear()
	for factory: Factory in _factory_manager.get_all_factories():
		if factory == null or factory.template_data == null:
			continue
		factory.data = factory.template_data.duplicate_data()
		factory.data.init()
		factory.data.is_purchased = false
		factory.data.normalize_dps(_factory_manager.tick_interval)
		factory._update_ui()
	_factory_manager._emit_cps_if_changed(true)


func _has_live_factory_manager() -> bool:
	return _factory_manager != null and is_instance_valid(_factory_manager)


func _has_live_shop() -> bool:
	return _shop != null and is_instance_valid(_shop)


func _read_save_file() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var json := JSON.new()
	var error := json.parse(file.get_as_text())
	file.close()
	if error != OK or typeof(json.data) != TYPE_DICTIONARY:
		push_warning("SaveManager: corrupted save file.")
		return {}
	var parsed: Dictionary = json.data
	var version := int(parsed.get("version", 0))
	if version < 1 or version > SAVE_VERSION:
		push_warning("SaveManager: unsupported save version %d." % version)
		return {}
	return parsed
