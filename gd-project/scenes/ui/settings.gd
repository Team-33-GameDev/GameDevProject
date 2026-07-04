extends Control

@onready var volume_slider = $ColorRect/volume_slider
@onready var volume_label = $ColorRect/volume_label
@onready var sfx_slider = $ColorRect/sfx_slider
@onready var sfx_label = $ColorRect/sfx_label
@onready var master_slider = $ColorRect/master_slider
@onready var master_label = $ColorRect/master_label
@onready var resolution_button = $ColorRect/resolution_label/resolution_button
@onready var fps_toggle = $ColorRect/fps_label/fps_toggle
@onready var fullscreen_toggle = $ColorRect/resolution_label/fullscreen_toggle
@onready var fullscreen_label = $ColorRect/resolution_label/fullscreen_label
@onready var back_button = $ColorRect/back_button

var config = ConfigFile.new()
var config_path = "user://settings.cfg"
var return_to_pause = false

# Доступные разрешения
var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_settings()
	
	# Подключение сигналов слайдеров
	volume_slider.connect("value_changed", _on_volume_changed)
	sfx_slider.connect("value_changed", _on_sfx_changed)
	master_slider.connect("value_changed", _on_master_changed)
	
	# FPS toggle
	if fps_toggle:
		fps_toggle.connect("toggled", _on_fps_toggled)
	
	# Fullscreen toggle
	if fullscreen_toggle:
		fullscreen_toggle.connect("toggled", _on_fullscreen_toggled)
	
	# Resolution button
	if resolution_button:
		resolution_button.item_selected.connect(_on_resolution_selected)
		_setup_resolution_button()
	
	# Hover на back кнопке
	if back_button:
		back_button.mouse_entered.connect(_on_back_button_mouse_entered)

func _setup_resolution_button():
	resolution_button.clear()
	var current_resolution = DisplayServer.window_get_size()
	var current_index = 1
	
	for i in range(resolutions.size()):
		var res = resolutions[i]
		resolution_button.add_item("%dx%d" % [res.x, res.y])
		if res == current_resolution:
			current_index = i
	
	resolution_button.select(current_index)

func load_settings():
	if config.load(config_path) == OK:
		var saved_music_volume = config.get_value("audio", "music_volume", 50)
		var saved_sfx_volume = config.get_value("audio", "sfx_volume", 50)
		var saved_master_volume = config.get_value("audio", "master_volume", 100)
		var saved_show_fps = config.get_value("display", "show_fps", false)
		var saved_fullscreen = config.get_value("display", "fullscreen", false)
		var saved_resolution_index = config.get_value("display", "resolution_index", 1)
		
		volume_slider.value = saved_music_volume
		sfx_slider.value = saved_sfx_volume
		master_slider.value = saved_master_volume
		
		if fps_toggle:
			fps_toggle.button_pressed = saved_show_fps
		
		if fullscreen_toggle:
			fullscreen_toggle.button_pressed = saved_fullscreen
		
		# Применяем настройки
		if saved_fullscreen:
			# Получаем нативное разрешение монитора
			var screen_resolution = DisplayServer.screen_get_size()
			# Сначала windowed с нативным разрешением
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(screen_resolution)
			# Ждём кадр
			await get_tree().process_frame
			# Потом exclusive fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			print("✅ Fullscreen: ", screen_resolution)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			if saved_resolution_index >= 0 and saved_resolution_index < resolutions.size():
				DisplayServer.window_set_size(resolutions[saved_resolution_index])
		
		update_volume_label()
		update_sfx_label()
		update_master_label()
		
		apply_music_volume(saved_music_volume)
		apply_sfx_volume(saved_sfx_volume)
		apply_master_volume(saved_master_volume)
		
		if fps_toggle:
			FpsManager.show_fps(saved_show_fps)
	else:
		volume_slider.value = 50
		sfx_slider.value = 50
		master_slider.value = 100
		
		if fps_toggle:
			fps_toggle.button_pressed = false
		
		if fullscreen_toggle:
			fullscreen_toggle.button_pressed = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
		update_volume_label()
		update_sfx_label()
		update_master_label()
func save_settings():
	config.set_value("audio", "music_volume", volume_slider.value)
	config.set_value("audio", "sfx_volume", sfx_slider.value)
	config.set_value("audio", "master_volume", master_slider.value)
	
	if fps_toggle:
		config.set_value("display", "show_fps", fps_toggle.button_pressed)
	
	if fullscreen_toggle:
		config.set_value("display", "fullscreen", fullscreen_toggle.button_pressed)
	
	config.save(config_path)

func _on_volume_changed(value):
	update_volume_label()
	apply_music_volume(value)
	save_settings()
	AudioManager.play_sfx("menu_hover")

func _on_sfx_changed(value):
	update_sfx_label()
	apply_sfx_volume(value)
	save_settings()
	AudioManager.play_sfx("menu_hover")

func _on_master_changed(value):
	update_master_label()
	apply_master_volume(value)
	save_settings()
	AudioManager.play_sfx("menu_hover")

func _on_fps_toggled(toggled_on: bool):
	FpsManager.show_fps(toggled_on)
	save_settings()
	AudioManager.play_sfx("menu_click")

func _on_fullscreen_toggled(toggled_on: bool):
	if toggled_on:
		# Используем exclusive fullscreen с нативным разрешением
		var screen_resolution = DisplayServer.screen_get_size()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(screen_resolution)
		await get_tree().process_frame
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		print("✅ Fullscreen: ", screen_resolution)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		var saved_index = config.get_value("display", "resolution_index", 1)
		if saved_index >= 0 and saved_index < resolutions.size():
			DisplayServer.window_set_size(resolutions[saved_index])
	
	save_settings()
	AudioManager.play_sfx("menu_click")
	save_settings()
	AudioManager.play_sfx("menu_click")

func _on_resolution_selected(index: int):
	if index >= 0 and index < resolutions.size():
		var new_resolution = resolutions[index]
		
		# Сохраняем индекс разрешения
		config.set_value("display", "resolution_index", index)
		
		var current_mode = DisplayServer.window_get_mode()
		
		# Если fullscreen — переключаем для применения
		if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(new_resolution)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_size(new_resolution)
			var screen_size = DisplayServer.screen_get_size()
			var window_pos = (screen_size - new_resolution) / 2
			DisplayServer.window_set_position(window_pos)
		
		print("✅ Разрешение: ", new_resolution)
		
		save_settings()
		AudioManager.play_sfx("menu_click")

func update_volume_label():
	volume_label.text = "Music: %d%%" % volume_slider.value

func update_sfx_label():
	sfx_label.text = "SFX: %d%%" % sfx_slider.value

func update_master_label():
	master_label.text = "Master: %d%%" % master_slider.value

func apply_music_volume(value):
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index != -1:
		var db = linear_to_db(value / 100.0)
		AudioServer.set_bus_volume_db(bus_index, db)

func apply_sfx_volume(value):
	var bus_index = AudioServer.get_bus_index("SFX")
	if bus_index != -1:
		var db = linear_to_db(value / 100.0)
		AudioServer.set_bus_volume_db(bus_index, db)

func apply_master_volume(value):
	var bus_index = AudioServer.get_bus_index("Master")
	if bus_index != -1:
		var db = linear_to_db(value / 100.0)
		AudioServer.set_bus_volume_db(bus_index, db)

func apply_fps_setting(show: bool):
	FpsManager.show_fps(show)

func _on_back_button_mouse_entered():
	AudioManager.play_sfx("menu_hover")

func _on_back_pressed():
	AudioManager.play_sfx("menu_click")
	save_settings()
	
	if return_to_pause:
		queue_free()
	else:
		get_tree().change_scene_to_file("res://scenes/ui/mainmenu.tscn")
