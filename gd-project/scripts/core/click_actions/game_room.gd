extends Node3D


@onready var mc_button = $MainRoom/Buttons/ClickButton
@onready var shop = $ShopSystem


var factory_scene = preload(
	"res://scenes/props/factory.tscn"
)

signal click

var test_sound_player: AudioStreamPlayer3D


func _ready() -> void:
	# Здесь раньше находилась отладочная команда:
	#
	# GameManager.click(100000000)
	#
	# Она полностью удалена.
	pass


func _on_click_button_button_clicked() -> void:
	shop.click.emit()


# Старые обработчики оставлены для совместимости
# с существующими соединениями сцены.
func _on_click_button_2_button_clicked() -> void:
	if shop.has_method("buy_factory"):
		shop.buy_factory(0)


func _on_click_button_3_button_clicked() -> void:
	if shop.has_method("buy_factory"):
		shop.buy_factory(1)


func _on_click_button_4_button_clicked() -> void:
	if shop.has_method("upgrade_factory_click"):
		shop.upgrade_factory_click(0)


func _on_click_button_5_button_clicked() -> void:
	if shop.has_method("upgrade_click_add"):
		shop.upgrade_click_add()


func _on_click_button_6_button_clicked() -> void:
	if shop.has_method("upgrade_click_mult"):
		shop.upgrade_click_mult()


func _on_click_button_7_button_clicked() -> void:
	if shop.has_method("upgrade_factory_click"):
		shop.upgrade_factory_click(1)
