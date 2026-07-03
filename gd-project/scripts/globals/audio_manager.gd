extends Node

var config = ConfigFile.new()
var config_path = "user://settings.cfg"

# Словарь звуков — легко добавлять новые
var sfx_sounds = {}
var music_tracks = {}

var current_music_player = null
var current_music_name = ""  # Имя текущей музыки

func _ready():
	load_audio_settings()

func load_audio_settings():
	if config.load(config_path) == OK:
		var music_vol = config.get_value("audio", "music_volume", 50)
		var sfx_vol = config.get_value("audio", "sfx_volume", 50)
		set_music_volume(music_vol)
		set_sfx_volume(sfx_vol)

func save_settings(music_vol, sfx_vol):
	config.set_value("audio", "music_volume", music_vol)
	config.set_value("audio", "sfx_volume", sfx_vol)
	config.save(config_path)

func set_music_volume(percent):
	var db = linear_to_db(percent / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)

func set_sfx_volume(percent):
	var db = linear_to_db(percent / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)

func register_sfx(name: String, stream: AudioStream):
	sfx_sounds[name] = stream

func register_music(name: String, stream: AudioStream):
	music_tracks[name] = stream

func play_sfx(name: String, pitch_scale = 1.0):
	if sfx_sounds.has(name) and sfx_sounds[name] != null:
		var player = AudioStreamPlayer.new()
		player.stream = sfx_sounds[name]
		player.bus = "SFX"
		player.pitch_scale = pitch_scale
		add_child(player)
		player.play()
		player.finished.connect(player.queue_free)

func play_music(name: String, loop = true):
	if music_tracks.has(name) and music_tracks[name] != null:
		# Если эта же музыка уже играет — не перезапускай
		if current_music_name == name and current_music_player != null:
			return  # Выходим, музыка уже играет
		
		if current_music_player:
			current_music_player.stop()
			current_music_player.queue_free()
		
		var stream = music_tracks[name].duplicate()
		stream.loop = loop
		var player = AudioStreamPlayer.new()
		player.stream = stream
		player.bus = "Music"
		add_child(player)
		player.play()
		current_music_player = player
		current_music_name = name  # Запоминаем имя текущей музыки

func stop_music():
	if current_music_player:
		current_music_player.stop()
		current_music_player.queue_free()
		current_music_player = null
		current_music_name = ""

func play_button_click():
	play_sfx("click")
