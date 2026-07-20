extends Node3D# Или Node3D/Control, в зависимости от того, что у тебя корневой узел

# Путь к сцене офиса. ЗАМЕНИ на свой актуальный путь!
const OFFICE_SCENE_PATH: String = "res://scenes/levels/game_room.tscn" 

# Небольшая задержка, чтобы игрок не нажал R случайно в момент смерти
var _can_restart: bool = false

func _ready() -> void:
	print("💀 Welcome to the Death Phase. Press R to restart.")
	
	# Страховка от случайного нажатия: активируем кнопку через 0.5 секунды
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(func(): _can_restart = true)

func _unhandled_input(event: InputEvent) -> void:
	# Проверяем, нажата ли наша зарегистрированная кнопка и разрешен ли рестарт
	if _can_restart and event.is_action_pressed("restart_game"):
		_restart_run()

func _restart_run() -> void:
	print(
		"🔄 Retrying quota %d..."
		% (QuotaManager.current_quota_index + 1)
	)
	
	# QuotaManager очистил только состояние неудачной попытки.
	# Индекс квоты, улучшения и мета-прогресс сохранены.
	
	# Загружаем сцену офиса заново
	get_tree().change_scene_to_file(OFFICE_SCENE_PATH)
