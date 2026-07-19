extends Control


signal close_requested


const REFERENCE_SIZE := Vector2(1152.0, 648.0)


@onready var title_label: Label = $Title

@onready var page1: Control = \
	$PagesController/Page1

@onready var page2: Control = \
	$PagesController/Page2

@onready var next_page_button: Button = \
	$PagesController/Page1/NextPageButton

@onready var prev_page_button: Button = \
	$PagesController/Page2/PrevPageButton

@onready var page1_factories_row: HBoxContainer = \
	$PagesController/Page1/FactoriesRow

@onready var page2_factories_row: HBoxContainer = \
	$PagesController/Page2/FactoriesRow

@onready var factory_slots = [
	$PagesController/Page1/FactoriesRow/WoodenFactory,
	$PagesController/Page1/FactoriesRow/StoneFactory,
	$PagesController/Page1/FactoriesRow/CooperFactory,
	$PagesController/Page2/FactoriesRow/IronFactory,
	$PagesController/Page2/FactoriesRow/GoldenFactory,
	$PagesController/Page2/FactoriesRow/DiamondFactory
]


var factory_manager = null
var current_page: int = 0

const TOTAL_PAGES: int = 2


func _ready() -> void:
	if not resized.is_connected(
		_apply_responsive_layout
	):
		resized.connect(
			_apply_responsive_layout
		)

	call_deferred("_apply_responsive_layout")

	_show_page(0)

	if not next_page_button.pressed.is_connected(
		_on_next_page_pressed
	):
		next_page_button.pressed.connect(
			_on_next_page_pressed
		)

	if not prev_page_button.pressed.is_connected(
		_on_prev_page_pressed
	):
		prev_page_button.pressed.connect(
			_on_prev_page_pressed
		)


func _apply_responsive_layout() -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		return

	var ui_scale: float = minf(
		size.x / REFERENCE_SIZE.x,
		size.y / REFERENCE_SIZE.y
	)

	ui_scale = maxf(ui_scale, 0.01)

	_scale_control(
		title_label,
		ui_scale,
		Vector2(0.5, 0.0)
	)
	_scale_control(
		page1_factories_row,
		ui_scale,
		Vector2(0.5, 0.5)
	)
	_scale_control(
		page2_factories_row,
		ui_scale,
		Vector2(0.5, 0.5)
	)
	_scale_control(
		next_page_button,
		ui_scale,
		Vector2(1.0, 0.5)
	)
	_scale_control(
		prev_page_button,
		ui_scale,
		Vector2(0.0, 0.5)
	)


func _scale_control(
	control: Control,
	ui_scale: float,
	pivot_ratio: Vector2
) -> void:
	control.pivot_offset = control.size * pivot_ratio
	control.scale = Vector2.ONE * ui_scale


func setup(manager) -> void:
	factory_manager = manager

	if factory_manager == null:
		push_error(
			"FactoryManagerScreen: manager is null."
		)
		return

	var factories = factory_manager.get_all_factories()
	var factory_count: int = factories.size()

	for index in range(factory_slots.size()):
		var slot = factory_slots[index]

		if index < factory_count:
			slot.setup(factory_manager, index)
		else:
			slot.show_unavailable()

	print(
		"FactoryManagerScreen connected %d backend factories."
		% factory_count
	)


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return

	if event.is_action_pressed("ui_cancel"):
		close_requested.emit()
		get_viewport().set_input_as_handled()


func _on_next_page_pressed() -> void:
	if current_page >= TOTAL_PAGES - 1:
		return

	current_page += 1
	_show_page(current_page)


func _on_prev_page_pressed() -> void:
	if current_page <= 0:
		return

	current_page -= 1
	_show_page(current_page)


func _show_page(page_index: int) -> void:
	current_page = clampi(
		page_index,
		0,
		TOTAL_PAGES - 1
	)

	page1.visible = current_page == 0
	page2.visible = current_page == 1
