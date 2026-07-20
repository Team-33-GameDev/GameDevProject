extends Node3D

@onready var mc_button = $MainRoom/Buttons/ClickButton
@onready var shop = $ShopSystem

var factory_scene = preload("res://scenes/props/factory.tscn")

signal click

var test_sound_player: AudioStreamPlayer3D

func _ready() -> void:
	
	if not QuotaManager.boss_intro_state_changed.is_connected(
		_on_boss_intro_state_changed
	):
		QuotaManager.boss_intro_state_changed.connect(
			_on_boss_intro_state_changed
		)

	# Дочерние узлы входят в дерево раньше GameRoom, поэтому
	# здесь можно сразу убрать кнопку из группы clickable.
	_on_boss_intro_state_changed(
		QuotaManager.is_boss_intro_active()
	)


func _on_boss_intro_state_changed(
	active: bool
) -> void:
	if mc_button == null:
		return

	if active:
		mc_button.remove_from_group(&"clickable")
	elif not mc_button.is_in_group(&"clickable"):
		mc_button.add_to_group(&"clickable")


func _on_click_button_button_clicked() -> void:
	# Дополнительная проверка защищает от вызова сигнала
	# другим кодом, пока монолог ещё не завершён.
	if QuotaManager.is_boss_intro_active():
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
