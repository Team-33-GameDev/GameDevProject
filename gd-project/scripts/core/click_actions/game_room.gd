extends Node3D

@onready var mc_button = $Buttons/ClickButton
@onready var shop = $Shop
var factory_scene = preload("res://scenes/props/factory.tscn")
signal click

func _ready():
	GameManager.click(100000000)
	


	
func _on_click_button_button_clicked() -> void:
	shop.click.emit()
