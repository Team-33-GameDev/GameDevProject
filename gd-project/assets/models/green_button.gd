extends Node3D
class_name GreenButton


signal button_clicked


@export var animation_name: StringName = \
	&"Cylinder_003Action"


@onready var interaction_area: Area3D = \
	$Area3D

@onready var collision_shape: CollisionShape3D = \
	$Area3D/CollisionShape3D


var _animation_player: AnimationPlayer
var _resolved_animation_name: StringName = &""


func _ready() -> void:
	_prepare_interaction_area()
	_connect_restore_display()
	_prepare_animation()

	print(
		"GreenButton READY: ",
		get_path(),
		" | owner: ",
		interaction_area.owner,
		" | layer: ",
		interaction_area.collision_layer
	)


func _prepare_interaction_area() -> void:
	# Существующая система игрока ищет
	# группу clickable именно у collider.owner.
	add_to_group(&"clickable")

	# Гарантируем, что owner коллизии —
	# корневой GreenButton со скриптом click().
	interaction_area.owner = self

	# RayCast3D игрока использует mask = 16,
	# то есть физический слой №5.
	interaction_area.collision_layer = 0
	interaction_area.set_collision_layer_value(
		5,
		true
	)

	interaction_area.collision_mask = 0
	interaction_area.monitoring = true
	interaction_area.monitorable = true

	collision_shape.disabled = false


func _connect_restore_display() -> void:
	var parent_node: Node = get_parent()

	if parent_node == null:
		push_warning(
			"GreenButton: parent node was not found."
		)
		return

	var stats_display: Node = \
		parent_node.get_node_or_null(
			"FactoryStatsDisplay"
		)

	if stats_display == null:
		push_warning(
			"GreenButton: FactoryStatsDisplay "
			+ "was not found next to the button."
		)
		return

	if not stats_display.has_method(
		"_on_restore_button_clicked"
	):
		push_warning(
			"GreenButton: restore method "
			+ "was not found."
		)
		return

	var restore_callable := Callable(
		stats_display,
		"_on_restore_button_clicked"
	)

	# В stats_screen.tscn сигнал уже может быть
	# подключён. Второй раз его не подключаем.
	if not button_clicked.is_connected(
		restore_callable
	):
		button_clicked.connect(
			restore_callable
		)

	print(
		"GreenButton connected to: ",
		stats_display.get_path()
	)


func _prepare_animation() -> void:
	_animation_player = \
		_find_animation_player(self)

	if _animation_player == null:
		push_warning(
			"GreenButton: AnimationPlayer "
			+ "was not found."
		)
		return

	_resolved_animation_name = \
		_resolve_animation_name(
			_animation_player
		)

	if _resolved_animation_name == &"":
		push_warning(
			"GreenButton: click animation "
			+ "was not found."
		)


func click() -> void:
	print(
		"GreenButton CLICK: ",
		get_path()
	)

	_play_click_animation()
	button_clicked.emit()


func _play_click_animation() -> void:
	if _animation_player == null:
		return

	if _resolved_animation_name == &"":
		return

	# Быстрое повторное нажатие перезапускает
	# анимацию с самого начала.
	_animation_player.stop()
	_animation_player.play(
		_resolved_animation_name
	)


func _find_animation_player(
	root: Node
) -> AnimationPlayer:
	if root is AnimationPlayer:
		return root as AnimationPlayer

	for child in root.get_children():
		var result: AnimationPlayer = \
			_find_animation_player(child)

		if result != null:
			return result

	return null


func _resolve_animation_name(
	player: AnimationPlayer
) -> StringName:
	if (
		animation_name != &""
		and player.has_animation(
			animation_name
		)
	):
		return animation_name

	for animation_value in \
		player.get_animation_list():

		var current_name := StringName(
			animation_value
		)

		var normalized_name: String = \
			String(current_name).to_lower()

		if normalized_name == "reset":
			continue

		if (
			normalized_name.contains("click")
			or normalized_name.contains("press")
			or normalized_name.contains("button")
		):
			return current_name

	for animation_value in \
		player.get_animation_list():

		var current_name := StringName(
			animation_value
		)

		if (
			String(current_name).to_lower()
			!= "reset"
		):
			return current_name

	return &""
