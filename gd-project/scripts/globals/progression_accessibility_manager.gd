extends Node
class_name ProgressionAccessibilityManager


const EXTENDED_SAVE_PATH := "user://progression_accessibility.json"
const EXTENDED_SAVE_VERSION: int = 1

const FACTORY_PROPERTIES: Array[StringName] = [
	&"is_purchased",
	&"click_value",
	&"click_ticks_period",
	&"cur_click_ticks",
	&"max_hp",
	&"cur_hp",
	&"rhpt",
	&"dmg",
	&"dps",
	&"base_dps",
	&"dmg_tick_period",
	&"cur_tick_dmg",
	&"is_factory_pause",
	&"upg_lvl_hp",
	&"upg_lvl_click",
	&"upg_lvl_dmg",
	&"upg_lvl_dmg_period",
	&"upg_lvl_rhpt",
	&"cur_price_hp",
	&"cur_price_click",
	&"cur_price_dmg",
	&"cur_price_dmg_period",
	&"cur_price_rhpt",
]

const CLICK_UPGRADE_PROPERTIES: Array[StringName] = [
	&"add_level",
	&"mult_level",
	&"percent_level",
	&"crit_level",
	&"total_clicks",
]

const BOSS_SUBTITLE_CUES: Array[Dictionary] = [
	{
		"start": 0.0,
		"end": 5.2,
		"text": "WELCOME TO YOUR NEW ASSIGNMENT, EMPLOYEE.",
	},
	{
		"start": 5.2,
		"end": 10.4,
		"text": "MEET EACH PRODUCTION QUOTA BEFORE THE TIMER EXPIRES.",
	},
	{
		"start": 10.4,
		"end": 15.7,
		"text": "UPGRADE YOUR OUTPUT AND KEEP THE FACTORIES RUNNING.",
	},
	{
		"start": 15.7,
		"end": 21.0,
		"text": "FAILURE WILL RESULT IN IMMEDIATE DISPOSAL.",
	},
]


var _checkpoint: Dictionary = {}
var _broken_barriers: Dictionary = {}

var _current_game_room: Node = null
var _factory_manager: Node = null
var _shop_backend: Node = null
var _last_scene_instance_id: int = 0

var _hud_layer: CanvasLayer = null
var _prompt_panel: PanelContainer = null
var _prompt_label: Label = null
var _subtitle_panel: PanelContainer = null
var _subtitle_label: Label = null
var _active_subtitle_text: String = ""
var _boss_voice_player: AudioStreamPlayer = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_checkpoint()
	_connect_save_signal()
	_create_hud()
	call_deferred("refresh_game_room")


func _process(_delta: float) -> void:
	var current_scene := get_tree().current_scene
	var scene_instance_id: int = 0

	if current_scene != null:
		scene_instance_id = current_scene.get_instance_id()

	if scene_instance_id != _last_scene_instance_id:
		_last_scene_instance_id = scene_instance_id
		call_deferred("refresh_game_room")

	_update_boss_subtitles()
	_update_interaction_prompt()


func refresh_game_room() -> void:
	var current_scene := get_tree().current_scene

	_current_game_room = null
	_factory_manager = null
	_shop_backend = null

	if (
		current_scene == null
		or not current_scene.scene_file_path.ends_with("game_room.tscn")
	):
		_hide_hud()
		return

	_current_game_room = current_scene
	call_deferred("_finish_game_room_refresh")


func _finish_game_room_refresh() -> void:
	if _current_game_room == null or not is_instance_valid(_current_game_room):
		return

	_sync_checkpoint_with_base_save()

	_factory_manager = get_tree().get_first_node_in_group(&"factory_manager")
	_shop_backend = get_tree().get_first_node_in_group(&"shop_backend")

	_face_player_toward_monitor()
	_restore_checkpoint()
	_connect_wooden_barriers()

	# Некоторые backend-узлы завершают собственную отложенную настройку
	# в том же кадре. Повторное применение делает порядок инициализации
	# независимым от конкретной версии сцены.
	call_deferred("_restore_checkpoint")


# ------------------------------------------------------------------
# Extended progression checkpoint
# ------------------------------------------------------------------

func _connect_save_signal() -> void:
	var callback := Callable(self, "_on_base_game_saved")

	if not SaveManager.is_connected(&"game_saved", callback):
		SaveManager.connect(&"game_saved", callback)


func _on_base_game_saved() -> void:
	_capture_checkpoint()
	_write_checkpoint()


func _capture_checkpoint() -> void:
	_checkpoint = {
		"version": EXTENDED_SAVE_VERSION,
		"quota_index": QuotaManager.current_quota_index,
		"factories": _capture_factories(),
		"click_upgrades": _capture_click_upgrades(),
		"crowbar_purchased": _capture_crowbar_purchase(),
		"broken_barriers": _broken_barriers.keys(),
	}


func _restore_checkpoint() -> void:
	if _checkpoint.is_empty():
		return

	_restore_factories(_checkpoint.get("factories", []))
	_restore_click_upgrades(_checkpoint.get("click_upgrades", {}))
	_restore_crowbar_purchase(
		bool(_checkpoint.get("crowbar_purchased", false))
	)
	_restore_broken_barriers()


func _capture_factories() -> Array:
	var result: Array = []

	for factory: Node in _get_factories():
		var data := _get_object_property(factory, &"data") as Object

		if data == null:
			result.append(null)
			continue

		var factory_state: Dictionary = {}
		for property_name: StringName in FACTORY_PROPERTIES:
			if _has_property(data, property_name):
				factory_state[str(property_name)] = data.get(property_name)

		result.append(factory_state)

	return result


func _restore_factories(saved_factories: Variant) -> void:
	if saved_factories is not Array:
		return

	var factories := _get_factories()
	var active_factories: Array = []

	for index in range(factories.size()):
		var factory: Node = factories[index]
		var data := _get_object_property(factory, &"data") as Object

		if data == null:
			continue

		if index < saved_factories.size() and saved_factories[index] is Dictionary:
			var saved_data: Dictionary = saved_factories[index]
			for property_name: StringName in FACTORY_PROPERTIES:
				var key := str(property_name)
				if saved_data.has(key) and _has_property(data, property_name):
					data.set(property_name, saved_data[key])

		if bool(_get_object_property(data, &"is_purchased", false)):
			active_factories.append(factory)

		if _factory_manager != null and _factory_manager.has_signal(&"factory_updated"):
			_factory_manager.emit_signal(&"factory_updated", factory)

	if _factory_manager != null and _has_property(_factory_manager, &"active_factories"):
		_factory_manager.set(&"active_factories", active_factories)

	if _factory_manager != null and _factory_manager.has_method(&"_emit_cps_if_changed"):
		_factory_manager.call(&"_emit_cps_if_changed", true)


func _get_factories() -> Array:
	if _factory_manager == null or not is_instance_valid(_factory_manager):
		return []

	if _factory_manager.has_method(&"get_all_factories"):
		var result: Variant = _factory_manager.call(&"get_all_factories")
		if result is Array:
			return result

	var fallback: Variant = _get_object_property(
		_factory_manager,
		&"all_factories",
		[]
	)
	return fallback if fallback is Array else []


func _capture_click_upgrades() -> Dictionary:
	var click_data := _get_click_upgrade_data()
	var result: Dictionary = {}

	if click_data == null:
		return result

	for property_name: StringName in CLICK_UPGRADE_PROPERTIES:
		if _has_property(click_data, property_name):
			result[str(property_name)] = click_data.get(property_name)

	return result


func _restore_click_upgrades(saved_upgrades: Variant) -> void:
	if saved_upgrades is not Dictionary:
		return

	var click_data := _get_click_upgrade_data()
	if click_data == null:
		return

	for property_name: StringName in CLICK_UPGRADE_PROPERTIES:
		var key := str(property_name)
		if saved_upgrades.has(key) and _has_property(click_data, property_name):
			click_data.set(property_name, saved_upgrades[key])


func _get_click_upgrade_data() -> Object:
	if _shop_backend == null or not is_instance_valid(_shop_backend):
		return null

	return _get_object_property(_shop_backend, &"click_upgrade_data")


func _capture_crowbar_purchase() -> bool:
	if _shop_backend == null or not is_instance_valid(_shop_backend):
		return false

	if _shop_backend.has_method(&"is_crowbar_purchased"):
		return bool(_shop_backend.call(&"is_crowbar_purchased"))

	return bool(
		_get_object_property(_shop_backend, &"_crowbar_purchased", false)
	)


func _restore_crowbar_purchase(is_purchased: bool) -> void:
	if _shop_backend != null and is_instance_valid(_shop_backend):
		if _shop_backend.has_method(&"restore_crowbar_purchased"):
			_shop_backend.call(&"restore_crowbar_purchased", is_purchased)
		elif _has_property(_shop_backend, &"_crowbar_purchased"):
			_shop_backend.set(&"_crowbar_purchased", is_purchased)

	var crowbar := get_tree().get_first_node_in_group(&"crowbar")
	if crowbar != null and crowbar.has_method(&"set_available"):
		crowbar.call(&"set_available", is_purchased)


func _connect_wooden_barriers() -> void:
	if _current_game_room == null:
		return

	for node: Node in _current_game_room.find_children("*", "RigidBody3D", true, false):
		if not node.has_signal(&"crash"):
			continue

		var progress_id := str(_current_game_room.get_path_to(node))

		if _broken_barriers.has(progress_id):
			node.queue_free()
			continue

		var callback := Callable(
			self,
			"_on_wooden_barrier_crashed"
		).bind(progress_id)

		if not node.is_connected(&"crash", callback):
			node.connect(&"crash", callback, CONNECT_ONE_SHOT)


func _on_wooden_barrier_crashed(progress_id: String) -> void:
	_broken_barriers[progress_id] = true
	_capture_checkpoint()
	_write_checkpoint()


func _restore_broken_barriers() -> void:
	if _current_game_room == null:
		return

	for node: Node in _current_game_room.find_children("*", "RigidBody3D", true, false):
		if not node.has_signal(&"crash"):
			continue

		var progress_id := str(_current_game_room.get_path_to(node))
		if _broken_barriers.has(progress_id):
			node.queue_free()


func _load_checkpoint() -> void:
	if (
		SaveManager.has_method(&"has_save")
		and not bool(SaveManager.call(&"has_save"))
	):
		if FileAccess.file_exists(EXTENDED_SAVE_PATH):
			DirAccess.remove_absolute(EXTENDED_SAVE_PATH)
		return

	if not FileAccess.file_exists(EXTENDED_SAVE_PATH):
		return

	var file := FileAccess.open(EXTENDED_SAVE_PATH, FileAccess.READ)
	if file == null:
		return

	var json := JSON.new()
	var error := json.parse(file.get_as_text())
	file.close()

	if error != OK or json.data is not Dictionary:
		push_warning("ProgressionAccessibilityManager: invalid checkpoint")
		return

	_checkpoint = json.data
	_broken_barriers.clear()

	var saved_barriers: Variant = _checkpoint.get("broken_barriers", [])
	if saved_barriers is Array:
		for progress_id: Variant in saved_barriers:
			_broken_barriers[str(progress_id)] = true


func _sync_checkpoint_with_base_save() -> void:
	if (
		not SaveManager.has_method(&"has_save")
		or bool(SaveManager.call(&"has_save"))
	):
		return

	_checkpoint.clear()
	_broken_barriers.clear()

	if FileAccess.file_exists(EXTENDED_SAVE_PATH):
		DirAccess.remove_absolute(EXTENDED_SAVE_PATH)


func _write_checkpoint() -> void:
	var file := FileAccess.open(EXTENDED_SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("ProgressionAccessibilityManager: checkpoint write failed")
		return

	file.store_string(JSON.stringify(_checkpoint, "\t"))
	file.close()


# ------------------------------------------------------------------
# Initial camera direction
# ------------------------------------------------------------------

func _face_player_toward_monitor() -> void:
	if _current_game_room == null:
		return

	var player_head := _current_game_room.get_node_or_null("Player/Head") as Node3D
	var monitor := _current_game_room.get_node_or_null(
		"MainRoom/monitor_system"
	) as Node3D

	if player_head == null or monitor == null:
		return

	var target_position := monitor.global_position
	target_position.y = player_head.global_position.y
	player_head.look_at(target_position, Vector3.UP)


# ------------------------------------------------------------------
# Contextual interaction prompts
# ------------------------------------------------------------------

static func format_interaction_prompt(
	input_name: String,
	description: String
) -> String:
	if input_name.is_empty() or description.is_empty():
		return ""

	return "[%s]  %s" % [input_name, description.to_upper()]


func _update_interaction_prompt() -> void:
	if (
		_current_game_room == null
		or not is_instance_valid(_current_game_room)
		or get_tree().paused
		or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED
	):
		_set_prompt_text("")
		return

	var aim_ray := _current_game_room.get_node_or_null(
		"Player/Head/Camera3D/RayCast3D"
	) as RayCast3D

	if aim_ray == null or not aim_ray.is_colliding():
		_set_prompt_text("")
		return

	var collider := aim_ray.get_collider() as Node
	if collider == null:
		_set_prompt_text("")
		return

	if collider.is_in_group(&"pickable"):
		_set_prompt_text(
			format_interaction_prompt(
				"LMB",
				_get_prompt_description(collider, "PICK UP")
			)
		)
		return

	if collider.is_in_group(&"interactable"):
		var interactable := _find_method_owner(collider, &"interact")
		if interactable != null:
			_set_prompt_text(
				format_interaction_prompt(
					"E",
					_get_prompt_description(interactable, "INTERACT")
				)
			)
			return

	if collider.is_in_group(&"clickable"):
		var clickable := _find_method_owner(collider, &"click")
		if clickable != null:
			_set_prompt_text(
				format_interaction_prompt(
					"LMB",
					_get_prompt_description(clickable, "USE")
				)
			)
			return

	_set_prompt_text("")


func _find_method_owner(node: Node, method_name: StringName) -> Node:
	var current: Node = node

	while current != null:
		if current.has_method(method_name):
			return current
		current = current.get_parent()

	if node.owner != null and node.owner.has_method(method_name):
		return node.owner

	return null


func _get_prompt_description(target: Node, fallback: String) -> String:
	if target.has_method(&"get_interaction_prompt"):
		var custom_text := str(target.call(&"get_interaction_prompt"))
		if not custom_text.is_empty():
			return custom_text

	var path_text := str(target.get_path()).to_lower()
	var node_name := target.name.to_lower()

	if "crowbar" in path_text or "lom" in path_text:
		return "PICK UP CROWBAR"
	if "door" in path_text:
		var can_open := bool(_get_object_property(target, &"can_open", true))
		return "OPEN DOOR" if can_open else "CLOSE DOOR"
	if "factory" in path_text and "manager" in path_text:
		return "OPEN FACTORY MANAGER"
	if "shop" in path_text:
		return "OPEN UPGRADE TERMINAL"
	if "big_button" in path_text:
		return "ACTIVATE QUOTA OVERRIDE"
	if "clickbutton" in node_name or "click_button" in path_text:
		return "PRESS PRODUCTION BUTTON"
	if "screen" in path_text or "display" in path_text or "monitor" in path_text:
		return "OPEN SCREEN"

	return fallback


# ------------------------------------------------------------------
# Boss subtitles
# ------------------------------------------------------------------

static func get_boss_subtitle_for_time(time_seconds: float) -> String:
	for cue: Dictionary in BOSS_SUBTITLE_CUES:
		if (
			time_seconds >= float(cue["start"])
			and time_seconds < float(cue["end"])
		):
			return str(cue["text"])

	return ""


func _update_boss_subtitles() -> void:
	if (
		_boss_voice_player == null
		or not is_instance_valid(_boss_voice_player)
		or not _boss_voice_player.playing
	):
		_boss_voice_player = _find_playing_boss_voice()

	if _boss_voice_player == null:
		_set_subtitle_text("")
		return

	_set_subtitle_text(
		get_boss_subtitle_for_time(
			_boss_voice_player.get_playback_position()
		)
	)


func _find_playing_boss_voice() -> AudioStreamPlayer:
	for node: Node in get_tree().get_nodes_in_group(&"boss_voice_player"):
		if node is AudioStreamPlayer and (node as AudioStreamPlayer).playing:
			return node as AudioStreamPlayer

	return null


# ------------------------------------------------------------------
# HUD construction
# ------------------------------------------------------------------

func _create_hud() -> void:
	_hud_layer = CanvasLayer.new()
	_hud_layer.name = "AccessibilityHUD"
	_hud_layer.layer = 118
	_hud_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_hud_layer)

	_prompt_panel = _create_panel(
		"InteractionPrompt",
		-112.0,
		-54.0,
		0.25,
		0.75
	)
	_prompt_label = _create_label(30)
	_prompt_panel.add_child(_prompt_label)
	_hud_layer.add_child(_prompt_panel)
	_prompt_panel.hide()

	_subtitle_panel = _create_panel(
		"BossSubtitles",
		-218.0,
		-128.0,
		0.12,
		0.88
	)
	_subtitle_label = _create_label(30)
	_subtitle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_subtitle_panel.add_child(_subtitle_label)
	_hud_layer.add_child(_subtitle_panel)
	_subtitle_panel.hide()


func _create_panel(
	panel_name: String,
	top_offset: float,
	bottom_offset: float,
	left_anchor: float,
	right_anchor: float
) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = panel_name
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.anchor_left = left_anchor
	panel.anchor_top = 1.0
	panel.anchor_right = right_anchor
	panel.anchor_bottom = 1.0
	panel.offset_top = top_offset
	panel.offset_bottom = bottom_offset

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.012, 0.025, 0.065, 0.90)
	panel_style.border_color = Color(0.32, 0.66, 0.96, 0.95)
	panel_style.set_border_width_all(2)
	panel_style.corner_radius_top_left = 5
	panel_style.corner_radius_top_right = 5
	panel_style.corner_radius_bottom_left = 5
	panel_style.corner_radius_bottom_right = 5
	panel_style.content_margin_left = 20.0
	panel_style.content_margin_top = 10.0
	panel_style.content_margin_right = 20.0
	panel_style.content_margin_bottom = 10.0
	panel.add_theme_stylebox_override(&"panel", panel_style)

	return panel


func _create_label(font_size: int) -> Label:
	var label := Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override(&"font_size", font_size)
	label.add_theme_color_override(&"font_color", Color(0.84, 0.94, 1.0))
	label.add_theme_color_override(&"font_outline_color", Color.BLACK)
	label.add_theme_constant_override(&"outline_size", 6)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _set_prompt_text(value: String) -> void:
	if _prompt_panel == null or _prompt_label == null:
		return

	_prompt_label.text = value
	_prompt_panel.visible = not value.is_empty()


func _set_subtitle_text(value: String) -> void:
	if _subtitle_panel == null or _subtitle_label == null:
		return

	if value == _active_subtitle_text:
		return

	_active_subtitle_text = value
	_subtitle_label.text = value
	_subtitle_panel.visible = not value.is_empty()


func _hide_hud() -> void:
	_set_prompt_text("")
	_set_subtitle_text("")


# ------------------------------------------------------------------
# Safe dynamic property access across project revisions
# ------------------------------------------------------------------

func _has_property(object: Object, property_name: StringName) -> bool:
	if object == null:
		return false

	for property_data: Dictionary in object.get_property_list():
		if StringName(property_data.get("name", "")) == property_name:
			return true

	return false


func _get_object_property(
	object: Object,
	property_name: StringName,
	fallback: Variant = null
) -> Variant:
	if not _has_property(object, property_name):
		return fallback

	return object.get(property_name)
