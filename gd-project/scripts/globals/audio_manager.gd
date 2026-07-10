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
# Для 3D звуков с позиционированием
func play_sfx_3d(sfx_name: String, position: Vector3, parent: Node, pitch: float = 1.0):
	if not sfx_sounds.has(sfx_name):
		print(" SFX не найден: ", sfx_name)
		return
	
	var player = AudioStreamPlayer3D.new()
	player.stream = sfx_sounds[sfx_name]
	player.pitch_scale = pitch
	
	# СНАЧАЛА добавляем в сцену
	parent.add_child(player)
	
	# ПОТОМ устанавливаем позицию
	player.global_position = position
	
	# Настройки затухания (Godot 4)
	player.max_distance = 20.0
	player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	player.unit_size = 1.0
	
	player.play()
	
	# Автоудаление после воспроизведения
	player.finished.connect(func(): 
		if player:
			player.queue_free()
	)

# Для звуков которые играют постоянно (эмбиент)
func play_sfx_3d_loop(sfx_name: String, position: Vector3, parent: Node):
	if not sfx_sounds.has(sfx_name):
		print("🔊 SFX не найден: ", sfx_name)
		return null
	
	var player = AudioStreamPlayer3D.new()
	player.stream = sfx_sounds[sfx_name]
	
	# СНАЧАЛА добавляем в сцену
	parent.add_child(player)
	
	# ПОТОМ устанавливаем позицию
	player.global_position = position
	
	# Настройки затухания (Godot 4)
	player.max_distance = 30.0
	player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	player.unit_size = 1.0
	player.bus = "SFX"
	
	player.play()
	
	return player

func stop_sfx_3d(player: AudioStreamPlayer3D):
	if player:
		player.stop()
		player.queue_free()
