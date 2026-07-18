extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 5.5
const SENSITIVITY = 0.005
const WIEGHT_DOWN = 1.5
@export var vel_down_con: int = -1
@export var min_angle: float = deg_to_rad(-85)
@export var max_angle: float = deg_to_rad(85)

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var aim_ray = $Head/Camera3D/RayCast3D
@onready var cam_sight = $Head/Camera3D/Cam_sight
@onready var aim_ray_end = $Head/Camera3D/RayCast3D/Marker3D

@export var throw_force: float = 15.0
@export var hold_distance: float = 1.5
@export var hold_offset: Vector3 = Vector3(0, -0.2, 0)
var is_pick: bool = false 

var aim_target
var held_object: RigidBody3D = null



# Звуки шагов
var footstep_timer: float = 0.0
var footstep_interval: float = 0.45
var was_moving: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Добавляем AudioListener для 3D звука
	var listener = AudioListener3D.new()
	$Head/Camera3D.add_child(listener)

func _unhandled_input(event: InputEvent) -> void:
	# Пауза на ESC
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if get_tree().paused:
			close_pause()
		else:
			open_pause()
		return
	
	# Если на паузе — не обрабатываем движение мыши
	if get_tree().paused:
		return
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, min_angle, max_angle)

func _input(event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Если на паузе — не обрабатываем движение
	if get_tree().paused:
		return
	
	if not is_on_floor():
		if (velocity.y <= vel_down_con):
			velocity += WIEGHT_DOWN * get_gravity() * delta
		else:
			velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Звуки шагов
	var is_moving = is_on_floor() and direction.length() > 0.1
	
	if is_moving and not was_moving:
		play_footstep()
		footstep_timer = 0.0
	elif is_moving and was_moving:
		footstep_timer += delta
		if footstep_timer >= footstep_interval:
			play_footstep()
			footstep_timer = 0.0
	else:
		footstep_timer = 0.0
	
	was_moving = is_moving

	aim_target = null 
	if aim_ray.get_collider():
		aim_target = aim_ray.get_collider()

	if aim_target:
		#print("Aim_target: ", aim_target.name)
		#print("Aim_target groups: ", aim_target.get_groups())
		#print("Aim_target parent: ", aim_target.get_parent().name if aim_target.get_parent() else "null")
		cam_sight.color = Color.GOLD
		if aim_target.is_in_group("interactable"):
			if Input.is_action_just_pressed("interact"):
				print("player: Iteract accept")
				var interactable = _find_interactable(aim_target)
				if interactable:
					interactable.interact()
				else:
					print("Did not found method")
				#elif aim_target.owner and aim_target.owner.has_method("click"):
					#print("player: Object can be clicked and found correct method")
					#aim_target.owner.click()
		if aim_target.is_in_group("clickable"):
			if Input.is_action_just_pressed("click"):
				print("player: Click accept")
				AudioManager.play_sfx("button_click")
				var clickable = _find_clickable(aim_target)
				if clickable:
					clickable.click()
				else:
					print("Did not found method")
				#elif aim_target.owner and aim_target.owner.has_method("click"):
					#print("player: Object can be clicked and found correct method")
					#aim_target.owner.click()
		if aim_target.is_in_group("pickable"):
			if Input.is_action_just_pressed("click"):
				if held_object == null:
					_pick_up(aim_target)
				elif held_object == aim_target and is_pick:
					_throw()
				#else:
					#_throw()
					#_pick_up(aim_target)
	else:
		cam_sight.color = Color.WHITE

	move_and_slide()
func _pick_up(object: RigidBody3D) -> void:
	is_pick = true
	if object == null or object == held_object:
		return

	if object is RigidBody3D:
		object.freeze = true

	var old_parent = object.get_parent()
	if old_parent:
		old_parent.remove_child(object)

	camera.add_child(object)
	#object.position = hold_offset + Vector3(0, 0, -hold_distance)
	object.position = aim_ray_end.position
	
	object.rotation = Vector3.ZERO

	held_object = object
	print("player: Picked up ", object.name)
func _find_clickable(node: Node) -> Node:
	if node.has_method("click"):
		return node
	var parent = node.get_parent()
	while parent:
		if parent.has_method("click"):
			return parent
		parent = parent.get_parent()
	if node.owner and node.owner.has_method("click"):
		return node.owner
	return null

func _find_interactable(node: Node) -> Node:
	if node.has_method("interact"):
		return node
	var parent = node.get_parent()
	while parent:
		if parent.has_method("interact"):
			return parent
		parent = parent.get_parent()
	if node.owner and node.owner.has_method("interact"):
		return node.owner
	return null

func _throw() -> void:
	is_pick = false 
	if held_object == null:
		return

	var object = held_object
	held_object = null

	camera.remove_child(object)

	var world = get_tree().current_scene
	if world:
		world.add_child(object)
		object.global_position = aim_ray_end.global_position 
		object.global_rotation = aim_ray_end.global_rotation 
	object.freeze = false
	object.apply_central_impulse((aim_ray_end.global_position - aim_ray.global_position) * throw_force)
	#if object is RigidBody3D:
		#object.freeze = false
		#var direction = -camera.global_transform.basis.z
		#object.apply_central_impulse(direction * throw_force)
	#else:
		#if object.has_method("set_linear_velocity"):
			#var direction = -camera.global_transform.basis.z
			#object.set_linear_velocity(direction * throw_force)

	print("player: Threw ", object.name)
	
func play_footstep():
	var pitch = randf_range(0.9, 1.1)
	AudioManager.play_sfx("footstep", pitch)

func open_pause():
	# Ищем PauseMenu по всему дереву сцен
	var pause_menu = get_tree().root.find_child("PauseMenu", true, false)
	if pause_menu == null:
		# Если не нашли по имени, ищем Control с pause_menu.gd
		pause_menu = get_tree().root.find_child("Control", true, false)
	if pause_menu and pause_menu.has_method("open_pause"):
		pause_menu.open_pause()

func close_pause():
	var pause_menu = get_tree().root.find_child("PauseMenu", true, false)
	if pause_menu == null:
		pause_menu = get_tree().root.find_child("Control", true, false)
	if pause_menu and pause_menu.has_method("close_pause"):
		pause_menu.close_pause()
