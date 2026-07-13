extends Node3D


@onready var factory_manager_entity: Node3D = \
	$factory_manager_entity

@onready var factory_manager_overlay: CanvasLayer = \
	$FactoryManagerOverlay

@onready var factory_manager_screen: Control = \
	$FactoryManagerOverlay/FactoryManagerScreen


func _ready() -> void:
	# Полноэкранный интерфейс должен продолжать получать ввод,
	# когда SceneTree поставлен на паузу.
	factory_manager_overlay.process_mode = \
		Node.PROCESS_MODE_WHEN_PAUSED

	factory_manager_overlay.visible = false

	if factory_manager_entity.has_signal(
		"factory_manager_opened"
	):
		if not factory_manager_entity.factory_manager_opened.is_connected(
			_open_factory_manager
		):
			factory_manager_entity.factory_manager_opened.connect(
				_open_factory_manager
			)
	else:
		push_error(
			"FactoryRoom: factory_manager_entity has no "
			+ "factory_manager_opened signal."
		)

	if factory_manager_screen.has_signal("close_requested"):
		if not factory_manager_screen.close_requested.is_connected(
			_close_factory_manager
		):
			factory_manager_screen.close_requested.connect(
				_close_factory_manager
			)
	else:
		push_error(
			"FactoryRoom: FactoryManagerScreen has no "
			+ "close_requested signal."
		)


func _open_factory_manager() -> void:
	factory_manager_overlay.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true


func _close_factory_manager() -> void:
	factory_manager_overlay.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
