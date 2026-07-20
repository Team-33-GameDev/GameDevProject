extends CanvasLayer


@onready var shop_screen: ClickShopScreen = $ClickShopScreen


var shop_station: Node = null
var shop_backend: Shop = null

var _paused_tree_by_shop: bool = false
var _previous_mouse_mode: int = Input.MOUSE_MODE_CAPTURED


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	visible = false

	shop_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	shop_screen.allow_close = true

	if not shop_screen.close_requested.is_connected(
		_close_shop
	):
		shop_screen.close_requested.connect(
			_close_shop
		)

	call_deferred("_setup_shop")


func _setup_shop() -> void:
	shop_station = _find_shop_station()
	shop_backend = _find_shop_backend()

	if shop_station == null:
		push_error(
			"ClickShopOverlay: ClickShopStation "
			+ "was not found."
		)
		return

	if not shop_station.has_signal(&"shop_opened"):
		push_error(
			"ClickShopOverlay: station has no "
			+ "shop_opened signal."
		)
		return

	var open_callable := Callable(
		self,
		"_open_shop"
	)

	if not shop_station.is_connected(
		&"shop_opened",
		open_callable
	):
		var error: Error = shop_station.connect(
			&"shop_opened",
			open_callable
		)

		if error != OK:
			push_error(
				"ClickShopOverlay: could not connect "
				+ "shop_opened signal."
			)
			return

	shop_screen.setup(shop_backend)
	_setup_preview_screen()

	if shop_backend == null:
		push_error(
			"ClickShopOverlay: ShopSystem was not found."
		)
	elif shop_backend.click_upgrade_data == null:
		push_error(
			"ClickShopOverlay: ShopSystem has no "
			+ "ClickUpgradeData resource."
		)

	print(
		"ClickShopOverlay: setup complete"
	)


func _find_shop_station() -> Node:
	var stations: Array[Node] = (
		get_tree().get_nodes_in_group(
			&"click_shop_station"
		)
	)

	if not stations.is_empty():
		return stations[0]

	var current_scene: Node = get_tree().current_scene

	if current_scene == null:
		return null

	return current_scene.find_child(
		"ClickShopStation",
		true,
		false
	)


func _find_shop_backend() -> Shop:
	var current_scene: Node = get_tree().current_scene

	if current_scene != null:
		var direct_backend: Node = (
			current_scene.get_node_or_null(
				"ShopSystem"
			)
		)

		if direct_backend is Shop:
			return direct_backend as Shop

	var backend_nodes: Array[Node] = (
		get_tree().get_nodes_in_group(
			&"shop_backend"
		)
	)

	for backend_node: Node in backend_nodes:
		if backend_node is Shop:
			return backend_node as Shop

	return null


func _setup_preview_screen() -> void:
	if shop_station == null:
		return

	if not shop_station.has_method(
		&"get_preview_screen"
	):
		return

	var candidate: Variant = shop_station.call(
		&"get_preview_screen"
	)

	if candidate is ClickShopScreen:
		var preview_screen := (
			candidate as ClickShopScreen
		)

		preview_screen.setup(shop_backend)


func _open_shop() -> void:
	if visible:
		return

	shop_backend = _find_shop_backend()
	shop_screen.setup(shop_backend)

	_previous_mouse_mode = Input.mouse_mode
	_paused_tree_by_shop = (
		not get_tree().paused
		and QuotaManager.should_pause_terminal_ui()
	)

	_set_station_preview_visible(false)

	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if _paused_tree_by_shop:
		get_tree().paused = true

	print("ClickShopOverlay: opened")


func _close_shop() -> void:
	if not visible:
		return

	visible = false

	if _paused_tree_by_shop:
		get_tree().paused = false

	_paused_tree_by_shop = false

	_set_station_preview_visible(true)

	Input.mouse_mode = _previous_mouse_mode

	print("ClickShopOverlay: closed")


func _set_station_preview_visible(
	is_visible: bool
) -> void:
	if shop_station == null:
		return

	if shop_station.has_method(
		&"set_preview_visible"
	):
		shop_station.call(
			&"set_preview_visible",
			is_visible
		)


func _exit_tree() -> void:
	if _paused_tree_by_shop:
		get_tree().paused = false

	_paused_tree_by_shop = false

	_set_station_preview_visible(true)
	Input.mouse_mode = _previous_mouse_mode
