extends RigidBody3D

signal crash
var is_collide: bool = false 
var destroy_time: float = 10.0
@onready var mesh_plate = $CollisionShape3D/Wooden_plate
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.freeze = true
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func destroy():
	print("DONE")
	queue_free()


#func _on_body_entered(body: Node) -> void:
	#print("YES I WAS HERE!")
	#if !is_collide and body.is_in_group("crowbar"):
		#crash.emit()
		#self.freeze = false
		
		


		#var tween = create_tween()
		#tween.tween_property(mesh_plate, "transparency", 1.0, destroy_time)
		#tween.finished.connect(destroy)



		





func _on_area_3d_body_entered(body: Node3D) -> void:
	if !is_collide and body.is_in_group("sledgehammer"):
		is_collide = true
		crash.emit()
		self.freeze = false
		var my_timer = Timer.new()
		add_child(my_timer)
		my_timer.wait_time = destroy_time
		my_timer.one_shot = true
		my_timer.timeout.connect(destroy)
		my_timer.start()
