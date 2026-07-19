extends RigidBody3D


@export var available_on_start: bool = false


var _is_available: bool = false


func _ready() -> void:
	set_available(available_on_start)


func set_available(value: bool) -> void:
	_is_available = value
	visible = value
	freeze = not value

	for node: Node in find_children(
		"*",
		"CollisionShape3D",
		true,
		false
	):
		var collision_shape := node as CollisionShape3D

		if collision_shape == null:
			continue

		collision_shape.set_deferred(
			"disabled",
			not value
		)

	if value:
		process_mode = Node.PROCESS_MODE_INHERIT
		sleeping = false
	else:
		process_mode = Node.PROCESS_MODE_DISABLED


func is_available() -> bool:
	return _is_available


func click() -> void:
	print("Crowbar: clicked")
