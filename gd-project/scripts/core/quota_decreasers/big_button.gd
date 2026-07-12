extends Node3D
signal button_clicked
@onready var anim = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@export var is_animating = false
@export var can_press = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("can_click_big_button"):
		if can_press:
			animation_tree.set("parameters/conditions/pressdown", true)
			button_clicked.emit()
		else:
			animation_tree.set("parameters/conditions/pressdown", false)
		can_press = false
		return
	animation_tree.set("parameters/conditions/pressdown", false)
	
	


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("can_click_big_button"):
		animation_tree.set("parameters/conditions/pressdown", false)
		can_press = true
		
