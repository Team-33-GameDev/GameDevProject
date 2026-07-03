extends Control

@onready var volume_slider = $ColorRect/volume_slider
@onready var volume_label = $ColorRect/volume_label
@onready var sfx_slider = $ColorRect/sfx_slider
@onready var sfx_label = $ColorRect/sfx_label
@onready var back_button = $ColorRect/back_button

var config = ConfigFile.new()
var config_path = "user://settings.cfg"
var return_to_pause = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	load_settings()
	
	volume_slider.connect("value_changed", _on_volume_changed)
	sfx_slider.connect("value_changed", _on_sfx_changed)
	
	if back_button:
		back_button.mouse_entered.connect(_on_back_button_mouse_entered)

func load_settings():
	if config.load(config_path) == OK:
		var saved_music_volume = config.get_value("audio", "music_volume", 50)
		var saved_sfx_volume = config.get_value("audio", "sfx_volume", 50)
		volume_slider.value = saved_music_volume
		sfx_slider.value = saved_sfx_volume
		update_volume_label()
		update_sfx_label()
	else:
		volume_slider.value = 50
		sfx_slider.value = 50
		update_volume_label()
		update_sfx_label()

func save_settings():
	config.set_value("audio", "music_volume", volume_slider.value)
	config.set_value("audio", "sfx_volume", sfx_slider.value)
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

func update_volume_label():
	volume_label.text = "Music: %d%%" % volume_slider.value

func update_sfx_label():
	sfx_label.text = "SFX: %d%%" % sfx_slider.value

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

func _on_back_button_mouse_entered():
	AudioManager.play_sfx("menu_hover")

func _on_back_pressed():
	AudioManager.play_sfx("menu_click")
	# Просто закрываем настройки
	# Родительское меню автоматически покажется снова
	queue_free()
