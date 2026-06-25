extends Node

# Состояния игры для контроля логики
enum GameState { IDLE, RUNNING, GAME_OVER }
var current_state: GameState = GameState.IDLE

# Список квот: время в секундах, необходимое количество очков
var quotas: Array = [
	[10.0, 200],
	[30.0, 500],
	[30.0, 1000],
	[30.0, 2500],
	[30.0, 5000]
]

var current_quota_index: int = 0
var time_left: float = 0.0
var current_quota_target: int = 0

# Переменная для предотвращения спама в консоли (выводим только при смене секунды)
var _last_printed_second: int = -1

func _ready() -> void:
	# Подписываемся на изменения очков, чтобы "услышать" первый клик игрока
	GameManager.score_changed.connect(_on_score_changed)
	print("=== QuotaManager initialized. Press the BIG BUTTON to start! ===")

func _process(delta: float) -> void:
	if current_state == GameState.RUNNING:
		time_left -= delta
		# Вывод в консоль раз в секунду
		var current_second = int(time_left)
		if current_second != _last_printed_second and current_second >= 0:
			_last_printed_second = current_second
			print("⏳ Time: %ds | Score: %d / %d" % [current_second, GameManager.score, current_quota_target])
		# Проверка окончания времени
		if time_left <= 0.0:
			_evaluate_quota()

# Этот метод срабатывает каждый раз, когда меняется score в GameManager
func _on_score_changed(new_score: int) -> void:
	# Если игра еще не начата и игрок сделал первый клик (очки > 0)
	if current_state == GameState.IDLE and new_score > 0:
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
	
	print("\n--- 🟢 RUN STARTED ---")
	print("🎯 Target Quota: %d | ⏱️ Time: %.1fs" % [current_quota_target, time_left])

func _evaluate_quota() -> void:
	print("\n--- ⏰ TIME IS UP ---")
	print("Final Score: %d | Required: %d" % [GameManager.score, current_quota_target])
	
	if GameManager.score >= current_quota_target:
		print("✅ SUCCESS! Quota reached.")
		
		GameManager.score = 0
		# Разница в очках, на которую надо будет покупать предметы
		# GameManager.score -= current_quota_target
		
		current_quota_index += 1
		current_state = GameState.IDLE 
		print("Preparation Phase... Click the button to start next quota!")
	else:
		print("FAILURE! Quota not reached. DISPOSAL INITIATED.")
		current_state = GameState.GAME_OVER
		_trigger_game_over()

func _trigger_game_over() -> void:
	print("💀 GAME OVER. Restarting simulation...")
	
	# Сбрасываем прогресс квот для новой игры
	current_quota_index = 0 
	
	# Сбрасываем очки (Важно! Autoload живет между сценами, поэтому обнуляем вручную)
	GameManager.score = 0 
	GameManager.add_tickets(current_quota_index)
	# Перезагружаем текущую сцену (комнату)
	get_tree().change_scene_to_file("res://scenes/levels/death_room.tscn")
