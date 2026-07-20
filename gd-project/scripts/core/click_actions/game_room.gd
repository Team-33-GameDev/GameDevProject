extends Node3D

const POST_RUN_BUTTON_COOLDOWN: float = 1.25

@onready var mc_button = $MainRoom/Buttons/ClickButton
@onready var shop = $ShopSystem

var factory_scene = preload("res://scenes/props/factory.tscn")

signal click

var test_sound_player: AudioStreamPlayer3D
var _boss_intro_active: bool = false
var _button_cooldown_active: bool = false

func _ready() -> void:
	
	if not QuotaManager.boss_intro_state_changed.is_connected(
		_on_boss_intro_state_changed
	):
		QuotaManager.boss_intro_state_changed.connect(
			_on_boss_intro_state_changed
		)

	if not QuotaManager.run_ended.is_connected(
		_on_run_ended
	):
		QuotaManager.run_ended.connect(
			_on_run_ended
		)

	# Дочерние узлы входят в дерево раньше GameRoom, поэтому
	# здесь можно сразу убрать кнопку из группы clickable.
	_on_boss_intro_state_changed(
		QuotaManager.is_boss_intro_active()
	)


func _on_boss_intro_state_changed(
	active: bool
) -> void:
	_boss_intro_active = active
	_refresh_click_button_availability()


func _on_run_ended(success: bool) -> void:
	if not success:
		return

	_button_cooldown_active = true
	_refresh_click_button_availability()

	var cooldown_timer: SceneTreeTimer = get_tree().create_timer(
		POST_RUN_BUTTON_COOLDOWN
	)
	cooldown_timer.timeout.connect(
		_finish_button_cooldown
	)


func _finish_button_cooldown() -> void:
	_button_cooldown_active = false
	_refresh_click_button_availability()


func _refresh_click_button_availability() -> void:
	if mc_button == null:
		return

	var is_available := (
		not _boss_intro_active
		and not _button_cooldown_active
	)

	if not is_available:
		mc_button.remove_from_group(&"clickable")
	elif not mc_button.is_in_group(&"clickable"):
		mc_button.add_to_group(&"clickable")

	if mc_button.has_method(&"set_interaction_enabled"):
		mc_button.call(
			&"set_interaction_enabled",
			is_available
		)


func _on_click_button_button_clicked() -> void:
	# Дополнительная проверка защищает от вызова сигнала
	# другим кодом, пока монолог ещё не завершён.
	if (
		QuotaManager.is_boss_intro_active()
		or _button_cooldown_active
	):
		return

	shop.click.emit()


# Старые обработчики оставлены для совместимости
# с существующими соединениями сцены.
func _on_click_button_2_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("buy_factory"): shop.buy_factory(0)

func _on_click_button_3_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("buy_factory"): shop.buy_factory(1)

func _on_click_button_4_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("upgrade_factory_click"): shop.upgrade_factory_click(0)

func _on_click_button_5_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("upgrade_click_add"): shop.upgrade_click_add()

func _on_click_button_6_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("upgrade_click_mult"): shop.upgrade_click_mult()

func _on_click_button_7_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("upgrade_factory_click"): shop.upgrade_factory_click(1)
