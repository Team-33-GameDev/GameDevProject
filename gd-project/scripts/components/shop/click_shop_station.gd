extends Node3D


signal shop_opened


const INTERACTION_LAYER: int = 16

const PREVIEW_DISPLAY_PATH: NodePath = \
	^"Cube_003/Node3D/ClickShopDisplay"

const PREVIEW_SCREEN_PATH: NodePath = \
	^"Cube_003/Node3D/ClickShopDisplay/SubViewport/ClickShopScreen"


func _ready() -> void:
	add_to_group(&"clickable")
	add_to_group(&"click_shop_station")

	_configure_interaction_areas()


func click() -> void:
	shop_opened.emit()


func get_preview_screen() -> ClickShopScreen:
	return get_node_or_null(
		PREVIEW_SCREEN_PATH
	) as ClickShopScreen


func set_preview_visible(
	is_visible: bool
) -> void:
	var preview_display := get_node_or_null(
		PREVIEW_DISPLAY_PATH
	) as Node3D

	if preview_display != null:
		preview_display.visible = is_visible


func _configure_interaction_areas() -> void:
	var area_nodes: Array[Node] = find_children(
		"*",
		"Area3D",
		true,
		false
	)

	if area_nodes.is_empty():
		push_error(
			"ClickShopStation: Area3D was not found."
		)
		return

	for area_node: Node in area_nodes:
		var interaction_area := area_node as Area3D

		if interaction_area == null:
			continue

		interaction_area.collision_layer = (
			INTERACTION_LAYER
		)
		interaction_area.collision_mask = 0
		interaction_area.monitoring = true
		interaction_area.monitorable = true

		# Игрок получает объект через:
		# aim_ray.get_collider().owner
		#
		# Поэтому владельцем Area3D должна быть станция,
		# на которой расположен метод click().
		interaction_area.owner = self
