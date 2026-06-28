extends Control

@onready var volume_slider = $ColorRect/volume_slider
@onready var volume_label = $ColorRect/volume_label

var config = ConfigFile.new()
var config_path = "user://settings.cfg"

func _ready():
	load_settings()
	
	volume_slider.connect("value_changed", _on_volume_changed)

func load_settings():
	if config.load(config_path) == OK:
		var saved_volume = config.get_value("audio", "music_volume", 50)
		volume_slider.value = saved_volume
		update_volume_label()
		apply_volume(saved_volume)
	else:
		volume_slider.value = 50
		update_volume_label()

func save_settings():
	config.set_value("audio", "music_volume", volume_slider.value)
	config.save(config_path)

func _on_volume_changed(value):
	update_volume_label()
	apply_volume(value)
	save_settings()

func update_volume_label():
	volume_label.text = "Music: %d%%" % volume_slider.value

func apply_volume(value):
	var db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(0, db)

func _on_back_pressed():
	save_settings()
	get_tree().change_scene_to_file("res://scenes/ui/mainmenu.tscn")
	
