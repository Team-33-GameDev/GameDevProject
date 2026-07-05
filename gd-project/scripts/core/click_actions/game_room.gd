extends Node3D

@onready var mc_button = $Buttons/ClickButton
@onready var shop = $ShopSystem
var factory_scene = preload("res://scenes/props/factory.tscn")
signal click

func _ready():
	#GameManager.click(100000000)
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/ui/mainmenu.tscn")

	
func _on_click_button_button_clicked() -> void:
	shop.click.emit()


func _on_click_button_2_button_clicked() -> void:
	shop.buy_factory(0)


func _on_click_button_3_button_clicked() -> void:
	shop.buy_factory(1)


func _on_click_button_4_button_clicked() -> void:
	shop.upgrade_factory_click(0)


func _on_click_button_5_button_clicked() -> void:
	shop.upgrade_click_add()


func _on_click_button_6_button_clicked() -> void:
	shop.upgrade_click_mult()


func _on_click_button_7_button_clicked() -> void:
	shop.upgrade_factory_click(1)
