extends Node
# SaveManager — автолоад. Порядок: GameManager, QuotaManager, ..., SaveManager

const SAVE_PATH := "user://savegame.json"
const SAVE_VERSION := 1

signal game_saved
signal game_loaded

# Ссылка на ресурс апгрейдов. Shop регистрирует себя при _ready.
var _click_upgrade_data: ClickUpgradeData = null

func _ready() -> void:
	# Автосейв на чекпоинте (квота выполнена)
	QuotaManager.preparation_phase_started.connect(save_game)
	# Ловим закрытие окна
	get_tree().set_auto_accept_quit(false)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()

# Магазин вызывает это в своём _ready, чтобы отдать ресурс апгрейдов
func register_click_upgrade_data(data: ClickUpgradeData) -> void:
	_click_upgrade_data = data
	# Если сейв был загружен раньше, чем магазин появился в сцене — доприменяем
	if _pending_upgrades != null:
		_apply_upgrades(_pending_upgrades)
		_pending_upgrades = null

var _pending_upgrades = null

func save_game() -> void:
	# Не сохраняемся посреди забега
	if QuotaManager.current_state == QuotaManager.GameState.RUNNING:
		return

	var data := {
		"version": SAVE_VERSION,
		"timestamp": Time.get_unix_time_from_system(),
		"quota_index": QuotaManager.current_quota_index,
		"tickets": GameManager.tickets,
		"additive_bonuses": GameManager._additive_bonuses,
		"multiplicative_bonuses": GameManager._multiplicative_bonuses,
		"upgrades": _serialize_upgrades(),
		"purchased_items": [],  # задел под предметы, меняющие локацию
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: cannot open save file: %s" % FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	game_saved.emit()
	print("💾 Game saved (quota %d)" % data["quota_index"])

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	file.close()
	if err != OK or typeof(json.data) != TYPE_DICTIONARY:
		push_warning("SaveManager: corrupted save file")
		return false
	var parsed: Dictionary = json.data

	var version := int(parsed.get("version", 0))
	if version < 1 or version > 5:
		push_warning("SaveManager: unsupported save version")
		return false
	# PR #226 wrote versions up to 5. The stable loader only consumes keys that
	# already existed in version 1, so those files can be read safely without
	# restoring the removed save-system implementation.

	# --- Восстановление состояния ---
	QuotaManager.current_quota_index = int(parsed.get("quota_index", 0))
	QuotaManager.current_state = QuotaManager.GameState.IDLE
	GameManager.score = 0

	GameManager.tickets = int(parsed.get("tickets", 0))
	GameManager.tickets_changed.emit(GameManager.tickets)

	GameManager._additive_bonuses.clear()
	for b in parsed.get("additive_bonuses", []):
		GameManager._additive_bonuses.append(int(b))
	GameManager._multiplicative_bonuses.clear()
	for f in parsed.get("multiplicative_bonuses", []):
		GameManager._multiplicative_bonuses.append(float(f))
	GameManager._recalculate_click_power()

	var upgrades = parsed.get("upgrades", {})
	if _click_upgrade_data != null:
		_apply_upgrades(upgrades)
	else:
		_pending_upgrades = upgrades  # магазин ещё не в сцене

	game_loaded.emit()
	print("📂 Game loaded (quota %d)" % QuotaManager.current_quota_index)
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)

func _serialize_upgrades() -> Dictionary:
	if _click_upgrade_data == null:
		return {}
	return {
		"add_level": _click_upgrade_data.add_level,
		"mult_level": _click_upgrade_data.mult_level,
		"percent_level": _click_upgrade_data.percent_level,
		"crit_level": _click_upgrade_data.crit_level,
	}

func _apply_upgrades(upgrades: Dictionary) -> void:
	_click_upgrade_data.add_level = int(upgrades.get("add_level", 0))
	_click_upgrade_data.mult_level = int(upgrades.get("mult_level", 0))
	_click_upgrade_data.percent_level = int(upgrades.get("percent_level", 0))
	_click_upgrade_data.crit_level = int(upgrades.get("crit_level", 0))

func reset_progress() -> void:
	delete_save()
	if _click_upgrade_data != null:
		_click_upgrade_data.add_level = 0
		_click_upgrade_data.mult_level = 0
		_click_upgrade_data.percent_level = 0
		_click_upgrade_data.crit_level = 0
		_click_upgrade_data.total_clicks = 0
	GameManager._additive_bonuses.clear()
	GameManager._multiplicative_bonuses.clear()
	GameManager._recalculate_click_power()
