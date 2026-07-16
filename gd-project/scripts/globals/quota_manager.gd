extends Node

signal preparation_phase_started()
signal timer_updated(time_left: float)
signal quota_updated(target: int)
signal run_started()
signal run_ended(success: bool)

# Состояния игры для контроля логики
enum GameState { IDLE, RUNNING, GAME_OVER }
var current_state: GameState = GameState.IDLE

# Список квот: время в секундах, необходимое количество очков
var quotas: Array = [
	[10.0, 30],
	[10.0, 100],
	[10.0, 2000],
	[30.0, 5000],
	[30.0, 11000]
]

var current_quota_index: int = 0
var time_left: float = 0.0
var current_quota_target: int = 0

# Переменная для предотвращения спама в консоли (выводим только при смене секунды)
var _last_printed_second: int = -1

func _ready() -> void:
	# Запускаем фазу только после активного клика игрока.
	GameManager.player_click_performed.connect(
		_on_player_click_performed
	)

	# Подписываемся на начало/конец фазы для управления музыкой.
	run_started.connect(_on_run_started)
	run_ended.connect(_on_run_ended)

	print(
		"=== QuotaManager initialized. "
		+ "Press the BIG BUTTON to start! ==="
	)

# Запуск музыки при начале фазы кликанья
func _on_run_started():
	AudioManager.play_music("game")

# Остановка музыки при окончании фазы
func _on_run_ended(success: bool):
	AudioManager.stop_music()

func _process(delta: float) -> void:
	if current_state == GameState.RUNNING:
		time_left -= delta
		timer_updated.emit(time_left)
		# Вывод в консоль раз в секунду
		var current_second = int(time_left)
		if current_second != _last_printed_second and current_second >= 0:
			_last_printed_second = current_second
			#print("⏳ Time: %ds | Score: %d / %d" % [current_second, GameManager.score, current_quota_target])
		# Проверка окончания времени
		if time_left <= 0.0:
			_evaluate_quota()

# Этот метод срабатывает каждый раз, когда меняется score в GameManager
func _on_player_click_performed(_amount: int) -> void:
	if (
		current_state == GameState.IDLE
		and GameManager.score > 0
	):
		_start_run()

func _start_run() -> void:
	if current_quota_index >= quotas.size():
		print("🏆 ВСЕ КВОТЫ ВЫПОЛНены! ВЫ ПОБЕДИЛИ (Демо-версия).")
		current_state = GameState.GAME_OVER
		return

	current_state = GameState.RUNNING
	var quota_data = quotas[current_quota_index]
	time_left = quota_data[0]
	current_quota_target = quota_data[1]
	_last_printed_second = -1 # Сбрасываем для корректного вывода
	run_started.emit()
	quota_updated.emit(current_quota_target)
	timer_updated.emit(time_left)
	
	#print("\n--- 🟢 RUN STARTED ---")
	#print("🎯 Target Quota: %d | ⏱️ Time: %.1fs" % [current_quota_target, time_left])

func _evaluate_quota() -> void:
	print("\n--- ⏰ TIME IS UP ---")
	print("Final Score: %d | Required: %d" % [GameManager.score, current_quota_target])
	var success = GameManager.score >= current_quota_target
	run_ended.emit(success)
	if GameManager.score >= current_quota_target:
		print("✅ SUCCESS! Quota reached.")
	
	# Вычитаем квоту из счета
		GameManager.score = 0
	
		current_quota_index += 1
		current_state = GameState.IDLE
	
	# Эмитим сигнал о начале фазы подготовки
		preparation_phase_started.emit()
	else:
		print("FAILURE! Quota not reached. DISPOSAL INITIATED.")
		current_state = GameState.GAME_OVER
		_trigger_game_over()

func _trigger_game_over() -> void:
	print("💀 GAME OVER. Restarting simulation...")
	
	GameManager.add_tickets(current_quota_index)
	
	SaveManager.reset_progress()
	
	current_quota_index = 0 
	
	GameManager.score = 0 
	current_state = GameState.IDLE 
	get_tree().change_scene_to_file("res://scenes/levels/death_room.tscn")

func pause_game() -> void:
	current_state = GameState.IDLE
	time_left = 0.0
	current_quota_index = 0
	_last_printed_second = -1
	
	# Сбросить очки
	GameManager.score = 0
	
	print("⏸️ Game paused and reset.")
func reset_game() -> void:
	# Полный сброс состояния игры
	current_state = GameState.IDLE
	current_quota_index = 0
	time_left = 0.0
	current_quota_target = 0
	_last_printed_second = -1
	GameManager.score = 0
	
	print("🔄 Game progress reset.")


#Some logic of qouta decreasing 
func decrease_quota(decrease_percent : float) -> bool:
	print("QuotaManager: 
	Target quota %d, 
	Decrease percent %.2f, 
	Total Decrease %d" % [current_quota_target, decrease_percent, int(float(current_quota_target) * decrease_percent)])

	current_quota_target -= int(float(current_quota_target) * decrease_percent)
	if (current_quota_target < 0): 
		current_quota_target = 0
		return false
	quota_updated.emit(current_quota_target)
	return true
