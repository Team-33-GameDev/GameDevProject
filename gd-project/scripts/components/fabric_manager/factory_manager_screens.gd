extends Control


signal close_requested


@onready var page1: Control = \
	$PagesController/Page1

@onready var page2: Control = \
	$PagesController/Page2

@onready var next_page_button: Button = \
	$PagesController/Page1/NextPageButton

@onready var prev_page_button: Button = \
	$PagesController/Page2/PrevPageButton


var current_page: int = 0
const TOTAL_PAGES: int = 2


func _ready() -> void:
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


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return

	if event.is_action_pressed("ui_cancel"):
		close_requested.emit()

		# Не даём тому же Escape открыть обычное PauseMenu
		# через player.gd.
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
