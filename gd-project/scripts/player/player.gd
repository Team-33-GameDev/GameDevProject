extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005

@export var min_angle: float = deg_to_rad(-85)
@export var max_angle: float = deg_to_rad(85)

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var aim_ray = $Head/Camera3D/RayCast3D
@onready var cam_sight = $Head/Camera3D/Cam_sight
var aim_target

signal interact

# Звуки шагов
var footstep_timer: float = 0.0
var footstep_interval: float = 0.45
var was_moving: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	process_mode = Node.PROCESS_MODE_ALWAYS

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
		velocity += get_gravity() * delta

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
		aim_target = aim_ray.get_collider().owner

	if aim_target:
		cam_sight.color = Color.GOLD
		if aim_target.is_in_group("interactable"):
			if Input.is_action_just_pressed("interact"):
				print("player: interact")
		if aim_target.is_in_group("clickable"):
			if Input.is_action_just_pressed("click"):
				print("player: Click accept")
				AudioManager.play_sfx("button_click")
				if aim_target.has_method("click"):
					print("player: Object can be clicked and found correct method")
					aim_target.click()
				elif aim_target.owner and aim_target.owner.has_method("click"):
					print("player: Object can be clicked and found correct method")
					aim_target.owner.click()
	else:
		cam_sight.color = Color.WHITE

	move_and_slide()

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
