extends Node3D
@export var template_data: QuotaData
var data: QuotaData


signal jump_registered
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	data = template_data.duplicate_data()
	data.init()
	data.is_purchased = false 



func _on_big_button_button_clicked() -> void:
	jump_registered.emit()
	print("Big Button Clicked")
	data.add_click()
	if data.use_ability():
		data.apply_decrease()
