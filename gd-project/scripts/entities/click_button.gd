extends Node3D

signal button_clicked
@onready var aniPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func click():
	print("click_button: has been clicked, click AGAIN!")
	button_clicked.emit()
	aniPlayer.play("Button_Clicked")
