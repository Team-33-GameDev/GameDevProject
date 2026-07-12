extends Control

@onready var page1: Control = $PagesController/Page1
@onready var page2: Control = $PagesController/Page2
@onready var next_page_button: Button = $PagesController/Page1/NextPageButton
@onready var prev_page_button: Button = $PagesController/Page2/PrevPageButton

# Текущая страница (0 = Page1, 1 = Page2)
var current_page: int = 0
var total_pages: int = 2

func _ready() -> void:
	# Инициализация: показываем только первую страницу
	_show_page(0)
	
	# Подключаем кнопки навигации
	if next_page_button:
		next_page_button.pressed.connect(_on_next_page_pressed)
	
	if prev_page_button:
		prev_page_button.pressed.connect(_on_prev_page_pressed)


func _on_next_page_pressed() -> void:
	if current_page < total_pages - 1:
		current_page += 1
		_show_page(current_page)

func _on_prev_page_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		_show_page(current_page)

func _show_page(page_index: int) -> void:
	# Скрываем все страницы
	if page1: page1.visible = false
	if page2: page2.visible = false
	
	# Показываем нужную
	match page_index:
		0:
			if page1: page1.visible = true
		1:
			if page2: page2.visible = true
