extends Node3D

@export var template_data: ShopItemData
var data: ShopItemData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	data = template_data.duplicate_data()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if template_data == null:
		push_error("Sledgehammer: template_data is null!")
		return
	
func click():
	print("Crow bar: has been clicked")
	pass
	#button_clicked.emit()
	#aniPlayer.play("Button_Clicked")
