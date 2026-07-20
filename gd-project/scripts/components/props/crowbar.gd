extends RigidBody3D


@export var available_on_start: bool = false


var _is_available: bool = false


func _ready() -> void:
	data = template_data.duplicate_data()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if template_data == null:
		push_error("Crowbar: template_data is null!")
		return
	
func click():
	print("Crow bar: has been clicked")
	pass
	#button_clicked.emit()
	#aniPlayer.play("Button_Clicked")
