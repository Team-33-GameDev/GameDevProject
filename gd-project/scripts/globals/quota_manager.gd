extends Node

signal preparation_phase_started()
signal timer_updated(time_left: float)
signal quota_updated(target: int)
signal run_started()
signal run_ended(success: bool)
signal boss_intro_state_changed(active: bool)

# Состояния игры для контроля логики
enum GameState { IDLE, RUNNING, GAME_OVER }

const VICTORY_ROOM_SCENE := "res://scenes/levels/victory_room.tscn"
const MINIMUM_QUOTA_RATIO: float = 0.70
var current_state: GameState = GameState.IDLE

# Список квот: время в секундах, необходимое количество очков
var quotas: Array = [
	[30.0, 100],
	[30.0, 200],
	[30.0, 800],
	[30.0, 1500]
]

var current_quota_index: int = 0
var time_left: float = 0.0
var current_quota_target: int = 0
var _base_quota_target: int = 0

# Пока идёт вступительный монолог, ручной клик не должен
# запускать квоту. Значение меняет TVDisplay.
var _boss_intro_active: bool = false

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
	# Не запускаем музыку если мы в меню
	if get_tree().current_scene.name.to_lower() == "mainmenu":
		return
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

func set_boss_intro_active(value: bool) -> void:
	if _boss_intro_active == value:
		return

	_boss_intro_active = value
	boss_intro_state_changed.emit(value)


func is_boss_intro_active() -> bool:
	return _boss_intro_active


# Этот метод срабатывает каждый раз, когда меняется score в GameManager
func _on_player_click_performed(_amount: int) -> void:
	if _boss_intro_active:
		return

	if (
		current_state == GameState.IDLE
		and GameManager.score > 0
	):
		_start_run()

func _start_run() -> void:
	if current_quota_index >= quotas.size():
		_trigger_victory()
		return

	current_state = GameState.RUNNING
	var quota_data = quotas[current_quota_index]
	time_left = quota_data[0]
	current_quota_target = quota_data[1]
	_base_quota_target = current_quota_target
	GameManager.notify_score_reservation_changed()
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

		# Квота сгорает, а заработанный сверх неё
		# излишек остаётся игроку для покупок.
		GameManager.score = maxi(
			GameManager.score - current_quota_target,
			0
		)
	
		current_quota_index += 1
		current_quota_target = 0
		_base_quota_target = 0

		if current_quota_index >= quotas.size():
			_trigger_victory()
			return

		current_state = GameState.IDLE
		GameManager.notify_score_reservation_changed()

	# Эмитим сигнал о начале фазы подготовки
		preparation_phase_started.emit()
	else:
		print("FAILURE! Quota not reached. DISPOSAL INITIATED.")
		current_state = GameState.GAME_OVER
		_trigger_game_over()

func _trigger_victory() -> void:
	print("🏆 ALL QUOTAS COMPLETED. ENTERING THE VICTORY ROOM.")
	time_left = 0.0
	current_quota_target = 0
	_base_quota_target = 0
	GameManager.score = 0
	current_state = GameState.GAME_OVER
	timer_updated.emit(0.0)

	# Переход вызывается отложенно, чтобы не удалять текущую сцену
	# посреди обработки таймера и сигналов текущего кадра.
	call_deferred("_open_victory_room")


func _open_victory_room() -> void:
	var error := get_tree().change_scene_to_file(VICTORY_ROOM_SCENE)
	if error != OK:
		push_error(
			"QuotaManager: failed to open victory room. Error code: %d"
			% error
		)


func _trigger_game_over() -> void:
	print("💀 GAME OVER. Restarting simulation...")
	
	GameManager.add_tickets(current_quota_index)
	
	current_quota_index = 0 
	current_quota_target = 0
	_base_quota_target = 0
	
	GameManager.score = 0 
	current_state = GameState.IDLE 
	SaveManager.save_after_death()
	get_tree().change_scene_to_file("res://scenes/levels/death_room.tscn")

func pause_game() -> void:
	current_state = GameState.IDLE
	time_left = 0.0
	current_quota_index = 0
	current_quota_target = 0
	_base_quota_target = 0
	_last_printed_second = -1
	
	# Сбросить очки
	GameManager.score = 0
	
	print("⏸️ Game paused and reset.")
func reset_game() -> void:
	# Полный сброс состояния игры
	_boss_intro_active = false
	current_state = GameState.IDLE
	current_quota_index = 0
	time_left = 0.0
	current_quota_target = 0
	_base_quota_target = 0
	_last_printed_second = -1
	GameManager.score = 0
	
	print("🔄 Game progress reset.")


# Кнопка в комнате помогает с квотой, но не заменяет основной цикл.
# За один забег цель можно снизить максимум на 30%.
func decrease_quota(decrease_percent: float) -> bool:
	if (
		current_state != GameState.RUNNING
		or decrease_percent <= 0.0
		or current_quota_target <= 0
		or _base_quota_target <= 0
	):
		return false

	var minimum_target: int = ceili(
		float(_base_quota_target)
		* MINIMUM_QUOTA_RATIO
	)
	var decrease_amount: int = maxi(
		1,
		int(float(current_quota_target) * decrease_percent)
	)
	var new_target: int = maxi(
		minimum_target,
		current_quota_target - decrease_amount
	)

	if new_target == current_quota_target:
		return false

	current_quota_target = new_target
	GameManager.notify_score_reservation_changed()
	quota_updated.emit(current_quota_target)
	return true
