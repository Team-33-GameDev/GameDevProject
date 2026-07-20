class_name IClickAction extends Node


# Called when the node enters the scene tree for the first time.
func getValue() -> int:
	assert(false, "IClickAction: The method getValue() must be overridden")
	return 0
	
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		SaveManager.save_before_return_to_menu()

		if has_node("/root/QuotaManager"):
			QuotaManager.reset_game()
		if has_node("/root/GameManager"):
			GameManager.reset_game()
		
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/ui/mainmenu.tscn")
