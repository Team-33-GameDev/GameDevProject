extends Node3D

@onready var mc_button = $Buttons/ClickButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mc_button.button_clicked.connect(_on_points_button_clicked)

func _on_points_button_clicked() -> void:
	GameManager.add_score(10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		# Полный сброс игры
		if has_node("/root/QuotaManager"):
			QuotaManager.pause_game()
		if has_node("/root/GameManager"):
			GameManager.reset_game()
		
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/ui/mainmenu.tscn")
