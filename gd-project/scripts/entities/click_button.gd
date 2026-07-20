extends Node3D

signal button_clicked
@onready var aniPlayer = $AnimationPlayer
@onready var button_model: GeometryInstance3D = $Button_Model

var _interaction_enabled: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func click():
	if not _interaction_enabled:
		return

	#print("Click_button: has been clicked, click AGAIN!")
	button_clicked.emit()
	aniPlayer.play("Button_Clicked")


func set_interaction_enabled(is_enabled: bool) -> void:
	_interaction_enabled = is_enabled
	button_model.transparency = 0.0 if is_enabled else 0.55
