extends Control

var settings_scene = preload("res://scenes/ui/settings.tscn")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Регистрация звуков
	AudioManager.register_sfx("menu_click", load("res://assets/audio/menuclick.wav"))
	AudioManager.register_sfx("menu_hover", load("res://assets/audio/menuselect.wav"))
	AudioManager.register_sfx("button_click", load("res://assets/audio/buttonpressed.wav"))
	AudioManager.register_sfx("footstep", load("res://assets/audio/footstep.wav"))
	AudioManager.register_sfx("Evilai", load("res://assets/audio/Evilai.mp3"))
	AudioManager.register_music("game", load("res://assets/audio/музончик для игры.mp3"))
	AudioManager.register_music("death_room", load("res://assets/audio/ambient.mp3.mp3"))
	
	# Запустить музыку меню
	AudioManager.play_music("death_room")
	
	# Подключить hover сигналы (с проверкой)
	var play_btn = $VBoxContainer/"play button"
	var settings_btn = $VBoxContainer/settings
	var quit_btn = $VBoxContainer/quit
	
	if play_btn:
		play_btn.mouse_entered.connect(_on_play_button_mouse_entered)
	if settings_btn:
		settings_btn.mouse_entered.connect(_on_settings_mouse_entered)
	if quit_btn:
		quit_btn.mouse_entered.connect(_on_quit_mouse_entered)

func _on_play_button_pressed():
	AudioManager.play_sfx("menu_click")
	AudioManager.stop_music()
	get_tree().change_scene_to_file("res://scenes/levels/game_room.tscn")

func _on_settings_pressed():
	AudioManager.play_sfx("menu_click")
	# Вместо смены сцены, добавляем настройки поверх
	var settings = settings_scene.instantiate()
	settings.return_to_pause = false
	add_child(settings)
	# Когда настройки закроются, ничего особого не делаем
	settings.tree_exited.connect(func(): pass)

func _on_quit_pressed():
	AudioManager.play_sfx("menu_click")
	get_tree().quit()

func _on_play_button_mouse_entered():
	AudioManager.play_sfx("menu_hover")

func _on_settings_mouse_entered():
	AudioManager.play_sfx("menu_hover")

func _on_quit_mouse_entered():
	AudioManager.play_sfx("menu_hover")
