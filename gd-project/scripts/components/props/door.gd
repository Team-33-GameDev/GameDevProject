extends RigidBody3D
@onready var animation_tree = $AnimationTree
@onready var anim = $AnimationPlayer
@export var can_open: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	print("Open the door")
	if can_open:
		animation_tree.set("parameters/conditions/open", true)
		animation_tree.set("parameters/conditions/close", false)
		can_open = false
		
	else:
		animation_tree.set("parameters/conditions/open", false)
		animation_tree.set("parameters/conditions/close", true)
		can_open = true
	
