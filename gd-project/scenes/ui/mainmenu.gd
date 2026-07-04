extends Control

var settings_scene = preload("res://scenes/ui/settings.tscn")

func _ready():
	# Загружаем настройки
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var saved_fullscreen = config.get_value("display", "fullscreen", false)
		var saved_resolution = config.get_value("display", "resolution_index", 1)
		
		if saved_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
		# Применяем разрешение
		var resolutions = [
			Vector2i(1280, 720),
			Vector2i(1600, 900),
			Vector2i(1920, 1080),
			Vector2i(2560, 1440),
			Vector2i(3840, 2160)
		]
		if saved_resolution >= 0 and saved_resolution < resolutions.size():
			DisplayServer.window_set_size(resolutions[saved_resolution])
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Регистрация звуков
	AudioManager.register_sfx("menu_click", load("res://assets/audio/menuclick.wav"))
	AudioManager.register_sfx("menu_hover", load("res://assets/audio/menuselect.wav"))
	AudioManager.register_sfx("button_click", load("res://assets/audio/buttonpressed.wav"))
	AudioManager.register_sfx("footstep", load("res://assets/audio/footstep.wav"))
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
	var settings = settings_scene.instantiate()
	settings.return_to_pause = false
	add_child(settings)
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
