extends RigidBody3D

signal crash

@export var persistent_id: String = ""
@export var destroy_time: float = 3.0

var is_collide: bool = false


func _ready() -> void:
	freeze = true
	if not persistent_id.is_empty() and SaveManager.is_board_broken(persistent_id):
		call_deferred("queue_free")


func destroy() -> void:
	if not persistent_id.is_empty():
		SaveManager.mark_board_broken(persistent_id)
	queue_free()


func _on_body_entered(body: Node) -> void:
	_try_break(body)


func _on_area_3d_body_entered(body: Node3D) -> void:
	_try_break(body)


func _try_break(body: Node) -> void:
	if is_collide or body == null or not body.is_in_group("crowbar"):
		return

	is_collide = true
	crash.emit()
	freeze = false

	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = maxf(destroy_time, 0.0)
	timer.one_shot = true
	timer.timeout.connect(destroy)
	timer.start()
