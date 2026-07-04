extends CanvasLayer

var fps_label: Label

func _ready():
	fps_label = Label.new()
	fps_label.name = "FPS_Label"
	fps_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	fps_label.position = Vector2(10, 10)
	fps_label.text = "FPS: 60"
	
	# Настраиваем шрифт
	var font_size = 24
	fps_label.add_theme_font_size_override("font_size", font_size)
	fps_label.add_theme_color_override("font_color", Color.WHITE)
	
	add_child(fps_label)
	
	# Читаем настройку при запуске
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var show_fps = config.get_value("display", "show_fps", false)
		visible = show_fps
	else:
		visible = false

func _process(_delta):
	if visible and fps_label:
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func show_fps(show: bool):
	visible = show
