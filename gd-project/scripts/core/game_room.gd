extends Node3D

@onready var mc_button = $Buttons/ClickButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mc_button.button_clicked.connect(_on_points_button_clicked)

func _on_points_button_clicked() -> void:
	GameManager.add_score(10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
