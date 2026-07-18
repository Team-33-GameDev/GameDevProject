extends Node3D


@onready var display: BigButtonDisplay = (
	$BigButtonDisplay
)


func _on_jump_registered() -> void:
	if not is_instance_valid(display):
		push_warning(
			"BigButtonScreen: display was not found."
		)
		return

	display.register_jump()
