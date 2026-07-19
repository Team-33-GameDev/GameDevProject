extends Node3D


@export_range(1.0, 5.0, 0.1)
var screamer_duration: float = 2.0

@export_range(0.0, 20.0, 0.5)
var shake_strength: float = 7.0


@onready var player: CharacterBody3D = $Player
@onready var cake_hitbox: StaticBody3D = $CakeHitbox

@onready var ambient: AudioStreamPlayer = $Ambient
@onready var scream_audio: AudioStreamPlayer = $ScreamAudio

@onready var screamer_overlay: CanvasLayer = $ScreamerOverlay
@onready var screamer_image: TextureRect = (
	$ScreamerOverlay/EyesCenter/EyesFrame/ScreamerImage
)
@onready var flash: ColorRect = $ScreamerOverlay/Flash


var _screamer_triggered: bool = false
var _image_start_position: Vector2


func _ready() -> void:
	screamer_overlay.hide()

	# Размер Control-узлов становится корректным после первого кадра.
	await get_tree().process_frame

	screamer_image.pivot_offset = screamer_image.size * 0.5
	_image_start_position = screamer_image.position


func click() -> void:
	trigger_screamer()


func trigger_screamer() -> void:
	if _screamer_triggered:
		return

	_screamer_triggered = true
	call_deferred("_play_screamer")


func _play_screamer() -> void:
	# Повторно нажать на торт больше нельзя.
	cake_hitbox.collision_layer = 0

	# Останавливаем управление игроком.
	player.process_mode = Node.PROCESS_MODE_DISABLED

	if ambient.playing:
		ambient.stop()

	screamer_overlay.show()

	await get_tree().process_frame

	screamer_image.pivot_offset = screamer_image.size * 0.5
	_image_start_position = screamer_image.position

	# Начальное состояние.
	screamer_image.position = _image_start_position
	screamer_image.scale = Vector2(0.82, 0.82)
	screamer_image.modulate = Color(1.0, 1.0, 1.0, 0.0)

	flash.color = Color(1.0, 1.0, 1.0, 0.9)

	scream_audio.play()

	# Резкое появление глаз и короткая белая вспышка.
	var intro_tween := create_tween()
	intro_tween.set_parallel(true)

	intro_tween.tween_property(
		screamer_image,
		"scale",
		Vector2.ONE,
		0.14
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	intro_tween.tween_property(
		screamer_image,
		"modulate",
		Color.WHITE,
		0.06
	)

	intro_tween.tween_property(
		flash,
		"color",
		Color(1.0, 1.0, 1.0, 0.0),
		0.10
	)

	await intro_tween.finished

	# Лёгкая тряска, которая постепенно становится слабее.
	var shake_duration := maxf(screamer_duration - 0.35, 0.0)
	var elapsed := 0.0

	while elapsed < shake_duration:
		await get_tree().process_frame

		var delta := get_process_delta_time()
		elapsed += delta

		var progress := elapsed / maxf(shake_duration, 0.001)
		var current_strength := lerpf(
			shake_strength,
			1.0,
			progress
		)

		screamer_image.position = (
			_image_start_position
			+ Vector2(
				randf_range(-current_strength, current_strength),
				randf_range(-current_strength, current_strength)
			)
		)

		# Небольшая пульсация, без сильного приближения.
		var pulse := 1.0 + sin(elapsed * 18.0) * 0.015
		screamer_image.scale = Vector2.ONE * pulse

	# Возвращаем картинку в центр.
	screamer_image.position = _image_start_position
	screamer_image.scale = Vector2.ONE

	# Финальное красное затемнение.
	var outro_tween := create_tween()
	outro_tween.set_parallel(true)

	outro_tween.tween_property(
		screamer_image,
		"modulate",
		Color(1.0, 1.0, 1.0, 0.0),
		0.18
	)

	outro_tween.tween_property(
		flash,
		"color",
		Color(0.45, 0.0, 0.0, 1.0),
		0.18
	)

	await outro_tween.finished

	get_tree().quit()
