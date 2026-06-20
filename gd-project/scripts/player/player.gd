extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005

@export var min_angle: float = deg_to_rad(-85)
@export var max_angle: float = deg_to_rad(85)
#@export var max_angle: float = deg_to_rad(85)


@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var aim_ray = $Head/Camera3D/RayCast3D
var aim_target
signal interact


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		
		#head.rotation.y = clamp(head.rotation.y, min_angle, max_angle)
		camera.rotation.x = clamp(camera.rotation.x, min_angle, max_angle)
		#camera.rotation.y = clamp(camera.rotation.x, min_angle, max_angle)
		
		#head.rotation.y = clamp(head.rotation.y, min_angle, max_angle)
		#camera.rotation.y = clamp(camera.rotation.y, deg_to_rad(0), deg_to_rad(90))
		

				
		
func _input(event: InputEvent) -> void:
	pass
	
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	aim_target = null 
	if aim_ray.get_collider():
		aim_target = aim_ray.get_collider().owner
		#print(aim_target)
		
	if aim_target and aim_target.is_in_group("interactable"):
		#print(aim_target)
		if Input.is_action_just_pressed("interact"):
			print("BRAVE BOY")
				#target.owner.interact.emit()
	if aim_target and aim_target.is_in_group("clickable"):
		#print(aim_target)
		if Input.is_action_just_pressed("click"):
			print("GOOD BOY")
	move_and_slide()
	
	


			
	
		
