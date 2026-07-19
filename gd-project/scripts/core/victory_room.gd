extends Node3D

@export_range(0.1, 5.0, 0.05) var screamer_duration: float = 0.85

@onready var player: CharacterBody3D = $Player
@onready var cake_hitbox: StaticBody3D = $CakeHitbox
@onready var screamer_overlay: CanvasLayer = $ScreamerOverlay
@onready var screamer_image: TextureRect = $ScreamerOverlay/ScreamerImage
@onready var flash: ColorRect = $ScreamerOverlay/Flash
@onready var scream_audio: AudioStreamPlayer = $ScreamAudio

var _screamer_triggered: bool = false


func _ready() -> void:
	screamer_overlay.visible = false

	# Control sizes are finalized after the first frame.
	await get_tree().process_frame
	screamer_image.pivot_offset = screamer_image.size * 0.5


# Called by Player._find_clickable() when the cake collider is clicked.
func click() -> void:
	if _screamer_triggered:
		return

	_screamer_triggered = true
	cake_hitbox.collision_layer = 0
	player.process_mode = Node.PROCESS_MODE_DISABLED

	screamer_overlay.visible = true
	screamer_image.scale = Vector2(0.35, 0.35)
	flash.color = Color(1.0, 1.0, 1.0, 0.95)
	scream_audio.play()

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		screamer_image,
		"scale",
		Vector2(1.8, 1.8),
		screamer_duration
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(
		flash,
		"color",
		Color(0.55, 0.0, 0.0, 0.72),
		0.08
	)

	await get_tree().create_timer(screamer_duration).timeout
	get_tree().quit()
