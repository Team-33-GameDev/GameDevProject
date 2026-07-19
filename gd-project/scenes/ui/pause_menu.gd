extends Control

var settings_scene = preload("res://scenes/ui/settings.tscn")

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if $VBoxContainer/resume_button.pressed.is_connected(_on_resume_pressed):
		$VBoxContainer/resume_button.pressed.disconnect(_on_resume_pressed)
	if $VBoxContainer/settings.pressed.is_connected(_on_settings_pressed):
		$VBoxContainer/settings.pressed.disconnect(_on_settings_pressed)
	if $VBoxContainer/menu_button.pressed.is_connected(_on_menu_pressed):
		$VBoxContainer/menu_button.pressed.disconnect(_on_menu_pressed)
	
	$VBoxContainer/resume_button.pressed.connect(_on_resume_pressed)
	$VBoxContainer/settings.pressed.connect(_on_settings_pressed)
	$VBoxContainer/menu_button.pressed.connect(_on_menu_pressed)

func _on_resume_pressed():
	AudioManager.play_sfx("menu_click")
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_settings_pressed():
	AudioManager.play_sfx("menu_click")
	# НЕ скрываем паузу, добавляем настройки поверх
	var settings = settings_scene.instantiate()
	settings.return_to_pause = true
	add_child(settings)
	# Настройки будут поверх паузы
	settings.tree_exited.connect(_on_settings_closed)

func _on_settings_closed():
	# Просто показываем паузу снова, она уже была под настройками
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_menu_pressed():
	AudioManager.play_sfx("menu_click")
	SaveManager.save_before_return_to_menu()
	get_tree().paused = false
	
	# Runtime очищается только после записи файла.
	QuotaManager.reset_game()
	GameManager.reset_game()
	
	# Переходим в главное меню
	get_tree().change_scene_to_file("res://scenes/ui/mainmenu.tscn")

func open_pause():
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close_pause():
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
