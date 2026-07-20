extends Node3D


@onready var factory_manager_entity: Node3D = \
	$factory_manager_entity

@onready var factory_manager_overlay: CanvasLayer = \
	$FactoryManagerOverlay

@onready var factory_manager_screen: Control = \
	$FactoryManagerOverlay/FactoryManagerScreen

@onready var factory_manager_preview_screen: Control = \
	get_node_or_null(
		"factory_manager_entity/"
		+ "Cube_003/Node3D/"
		+ "FactoryManagerDisplay/"
		+ "SubViewport/"
		+ "FactoryManagerScreen"
	)

@onready var factory_backend: FactoryManager = \
	$FactoryBackend

var _paused_tree_by_factory_manager: bool = false

func _ready() -> void:
	# Терминал работает и во время активной квоты, когда таймер
	# должен продолжать идти, и во время поставленной на паузу
	# подготовительной фазы.
	factory_manager_overlay.process_mode = \
		Node.PROCESS_MODE_ALWAYS
	factory_manager_screen.process_mode = \
		Node.PROCESS_MODE_ALWAYS

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
	call_deferred("_setup_factory_backend")

func _setup_factory_backend() -> void:
	if factory_backend == null:
		push_error(
			"FactoryRoom: FactoryBackend was not found."
		)
		return

	var factories = factory_backend.get_all_factories()

	if factories.is_empty():
		push_error(
			"FactoryRoom: FactoryBackend found no factories."
		)
		return

	# Полноэкранный интерактивный UI.
	factory_manager_screen.setup(factory_backend)

	# UI, который отображается на физическом терминале.
	if factory_manager_preview_screen == null:
		push_warning(
			"FactoryRoom: preview FactoryManagerScreen "
			+ "was not found."
		)
	elif not factory_manager_preview_screen.has_method("setup"):
		push_warning(
			"FactoryRoom: preview screen has no setup() method."
		)
	else:
		factory_manager_preview_screen.setup(
			factory_backend
		)

	print(
		"Factory backend connected. Factories: %d"
		% factories.size()
	)

func _open_factory_manager() -> void:
	if factory_backend != null:
		factory_manager_screen.setup(factory_backend)

	_paused_tree_by_factory_manager = (
		not get_tree().paused
		and QuotaManager.should_pause_terminal_ui()
	)

	factory_manager_overlay.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if _paused_tree_by_factory_manager:
		get_tree().paused = true


func _close_factory_manager() -> void:
	factory_manager_overlay.visible = false

	if _paused_tree_by_factory_manager:
		get_tree().paused = false

	_paused_tree_by_factory_manager = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _exit_tree() -> void:
	if _paused_tree_by_factory_manager:
		get_tree().paused = false

	_paused_tree_by_factory_manager = false
