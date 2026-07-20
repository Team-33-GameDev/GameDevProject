extends SubViewport


const BOSS_VOICE: AudioStream = preload(
	"res://assets/audio/Evilai.mp3"
)


@export var eyes_screen: Control
@export var score_screen: Control


var lbl_score_title: Label
var lbl_score_val: Label

var lbl_quota_title: Label
var lbl_quota_val: Label

var lbl_timer: Label
var lbl_cps: Label
var lbl_cost: Label


var _intro_active: bool = true

# Общая ссылка для всех экземпляров TVDisplay.
# Не позволяет двум вступительным голосам звучать одновременно.
static var _active_boss_voice_player: AudioStreamPlayer

var _boss_voice_player: AudioStreamPlayer
var _factory_manager: FactoryManager
var _shop_backend: Shop


func _ready() -> void:
	_find_labels()
	_setup_labels()
	_connect_global_signals()

	# Пока монолог не завершён, основная кнопка не должна
	# начислять очки или запускать клик-фазу.
	QuotaManager.set_boss_intro_active(true)

	# Глаза должны быть видны с первого кадра.
	_intro_active = true
	_show_eyes()
	_update_display()

	# Backend-узлы могут завершить свой _ready()
	# немного позже этого SubViewport.
	call_deferred("_connect_factory_manager")
	call_deferred("_connect_shop_backend")

	# === ЖЕЛЕЗОБЕТОННАЯ ПРОВЕРКА ===
	# Проверяем путь к файлу текущей сцены.
	var current_scene_path = get_tree().current_scene.scene_file_path

	# Если путь не заканчивается на "game_room.tscn", значит мы в меню или другой сцене
	if current_scene_path == null or not current_scene_path.ends_with("game_room.tscn"):
		print("🔇 TVDisplay: Мы в меню (сцена: ", current_scene_path, "). Голос отменен.")
		_intro_active = false
		_show_main_screen() # Сразу показываем обычный экран
		return # ПРЕРЫВАЕМ выполнение, _play_boss_intro() НЕ вызовется

	# Если мы дошли сюда, значит это НАСТОЯЩАЯ игра
	await _play_boss_intro()

	# Узел мог быть удалён во время смены сцены.
	if not is_inside_tree():
		return

	_intro_active = false
	QuotaManager.set_boss_intro_active(false)

	_show_main_screen()
	_update_display()


func _exit_tree() -> void:
	var owns_active_intro: bool = (
		_boss_voice_player != null
		and _active_boss_voice_player == _boss_voice_player
	)

	_stop_own_boss_voice()

	# Старый экран не должен снять блокировку, если новый
	# экран уже успел запустить собственный монолог.
	if _intro_active and owns_active_intro:
		QuotaManager.set_boss_intro_active(false)

	_disconnect_shop_backend()


# -------------------------------------------------------------------
# Инициализация
# -------------------------------------------------------------------

func _connect_global_signals() -> void:
	if not GameManager.score_changed.is_connected(
		_on_score_changed
	):
		GameManager.score_changed.connect(
			_on_score_changed
		)

	if not QuotaManager.timer_updated.is_connected(
		_on_timer_updated
	):
		QuotaManager.timer_updated.connect(
			_on_timer_updated
		)

	if not QuotaManager.run_started.is_connected(
		_on_run_started
	):
		QuotaManager.run_started.connect(
			_on_run_started
		)

	if not QuotaManager.run_ended.is_connected(
		_on_run_ended
	):
		QuotaManager.run_ended.connect(
			_on_run_ended
		)

	if not QuotaManager.preparation_phase_started.is_connected(
		_on_preparation_phase_started
	):
		QuotaManager.preparation_phase_started.connect(
			_on_preparation_phase_started
		)

	if (
		QuotaManager.has_signal("quota_updated")
		and not QuotaManager.quota_updated.is_connected(
			_on_quota_updated
		)
	):
		QuotaManager.quota_updated.connect(
			_on_quota_updated
		)


func _connect_factory_manager() -> void:
	# Несколько кадров ожидания защищают от различного
	# порядка инициализации вложенных сцен.
	for _attempt in range(10):
		var candidate: Node = (
			get_tree().get_first_node_in_group(
				"factory_manager"
			)
		)

		if candidate is FactoryManager:
			_factory_manager = candidate as FactoryManager
			break

		await get_tree().process_frame

	if _factory_manager == null:
		push_warning(
			"TVDisplay: FactoryManager was not found. "
			+ "CPS will remain 0."
		)

		_update_cps_display(0.0)
		return

	if not _factory_manager.cps_changed.is_connected(
		_on_cps_changed
	):
		_factory_manager.cps_changed.connect(
			_on_cps_changed
		)

	_update_cps_display(
		_factory_manager.get_total_cps()
	)


func _connect_shop_backend() -> void:
	# TVDisplay находится внутри SubViewport и может
	# инициализироваться раньше корневого ShopSystem.
	for _attempt in range(10):
		var current_scene: Node = get_tree().current_scene

		# Сначала ищем основной backend по ожидаемому пути.
		if current_scene != null:
			var direct_backend: Node = (
				current_scene.get_node_or_null(
					"ShopSystem"
				)
			)

			if direct_backend is Shop:
				_shop_backend = direct_backend as Shop
				break

		# Запасной поиск через группу.
		var grouped_backend: Node = (
			get_tree().get_first_node_in_group(
				"shop_backend"
			)
		)

		if grouped_backend is Shop:
			_shop_backend = grouped_backend as Shop
			break

		await get_tree().process_frame

	if _shop_backend == null:
		push_warning(
			"TVDisplay: ShopSystem was not found. "
			+ "Click power will remain 1."
		)

		_update_click_power_display(1)
		return

	if not _shop_backend.click_upgraded.is_connected(
		_on_click_upgraded
	):
		_shop_backend.click_upgraded.connect(
			_on_click_upgraded
		)

	_update_click_power_display(
		_get_current_click_power()
	)


func _disconnect_shop_backend() -> void:
	if _shop_backend == null:
		return

	if not is_instance_valid(_shop_backend):
		_shop_backend = null
		return

	if _shop_backend.click_upgraded.is_connected(
		_on_click_upgraded
	):
		_shop_backend.click_upgraded.disconnect(
			_on_click_upgraded
		)

	_shop_backend = null


# -------------------------------------------------------------------
# Вступительный голос
# -------------------------------------------------------------------

func _play_boss_intro() -> void:
	# При повторной загрузке комнаты старый голос может
	# существовать до конца текущего кадра. Останавливаем
	# все предыдущие экземпляры до запуска нового.
	_stop_existing_boss_voices()

	var player := AudioStreamPlayer.new()

	player.name = "BossVoicePlayer"
	player.stream = BOSS_VOICE
	player.bus = "SFX"

	_boss_voice_player = player
	_active_boss_voice_player = player

	add_child(player)

	player.add_to_group(
		&"boss_voice_player"
	)

	player.play()

	# Глаза останутся на экране ровно до завершения записи.
	await player.finished

	if is_instance_valid(player):
		player.queue_free()

	if _boss_voice_player == player:
		_boss_voice_player = null

	if _active_boss_voice_player == player:
		_active_boss_voice_player = null


func _stop_existing_boss_voices() -> void:
	var previous_active: AudioStreamPlayer = (
		_active_boss_voice_player
	)

	if is_instance_valid(previous_active):
		previous_active.stop()

		if not previous_active.is_queued_for_deletion():
			previous_active.queue_free()

	_active_boss_voice_player = null

	for node: Node in get_tree().get_nodes_in_group(
		&"boss_voice_player"
	):
		if not is_instance_valid(node):
			continue

		if node == previous_active:
			continue

		if node is AudioStreamPlayer:
			(node as AudioStreamPlayer).stop()

		if not node.is_queued_for_deletion():
			node.queue_free()


func _stop_own_boss_voice() -> void:
	if not is_instance_valid(_boss_voice_player):
		_boss_voice_player = null
		return

	_boss_voice_player.stop()

	if not _boss_voice_player.is_queued_for_deletion():
		_boss_voice_player.queue_free()

	if _active_boss_voice_player == _boss_voice_player:
		_active_boss_voice_player = null

	_boss_voice_player = null


# -------------------------------------------------------------------
# Получение Label
# -------------------------------------------------------------------

func _find_labels() -> void:
	if score_screen == null:
		push_error(
			"TVDisplay: score_screen is not assigned."
		)
		return

	lbl_score_title = score_screen.get_node_or_null(
		"Score"
	) as Label

	lbl_score_val = score_screen.get_node_or_null(
		"ScoreValue"
	) as Label

	lbl_quota_title = score_screen.get_node_or_null(
		"Quota"
	) as Label

	lbl_quota_val = score_screen.get_node_or_null(
		"QuotaValue"
	) as Label

	lbl_timer = score_screen.get_node_or_null(
		"Timer"
	) as Label

	lbl_cps = score_screen.get_node_or_null(
		"CPS"
	) as Label

	lbl_cost = score_screen.get_node_or_null(
		"Cost"
	) as Label


func _setup_labels() -> void:
	var labels: Array[Label] = [
		lbl_score_title,
		lbl_score_val,
		lbl_quota_title,
		lbl_quota_val,
		lbl_timer,
		lbl_cps,
		lbl_cost
	]

	for label: Label in labels:
		if label == null:
			continue

		label.horizontal_alignment = (
			HORIZONTAL_ALIGNMENT_CENTER
		)

		label.vertical_alignment = (
			VERTICAL_ALIGNMENT_CENTER
		)

		label.pivot_offset = label.size / 2.0


# -------------------------------------------------------------------
# Переключение экранов
# -------------------------------------------------------------------

func _show_eyes(
	_message: String = ""
) -> void:
	if eyes_screen != null:
		eyes_screen.show()

	if score_screen != null:
		score_screen.hide()


func _show_main_screen() -> void:
	if eyes_screen != null:
		eyes_screen.hide()

	if score_screen != null:
		score_screen.show()


func show_eyes_temporarily(
	duration: float = 3.0,
	message: String = ""
) -> void:
	_show_eyes(message)

	await get_tree().create_timer(
		duration
	).timeout

	if not _intro_active:
		_show_main_screen()


# -------------------------------------------------------------------
# Score, quota и timer
# -------------------------------------------------------------------

func _on_score_changed(
	new_score: int
) -> void:
	if lbl_score_val != null:
		lbl_score_val.text = str(new_score)


func _on_timer_updated(
	time_left: float
) -> void:
	if lbl_timer == null:
		return

	var minutes: int = int(time_left / 60.0)
	var seconds: int = int(time_left) % 60

	lbl_timer.text = "%02d:%02d" % [
		minutes,
		seconds
	]

	if time_left <= 5.0:
		lbl_timer.modulate = Color.RED
	else:
		lbl_timer.modulate = Color.WHITE


func _on_quota_updated(
	target: int
) -> void:
	if lbl_quota_val != null:
		lbl_quota_val.text = str(target)


func _on_run_started() -> void:
	# Старт квоты не должен убирать глаза,
	# пока запись босса ещё играет.
	if not _intro_active:
		_show_main_screen()

	if lbl_quota_title != null:
		lbl_quota_title.text = "QUOTA"

	_update_quota_display()

	if lbl_timer != null:
		lbl_timer.modulate = Color.WHITE


func _on_run_ended(
	success: bool
) -> void:
	if _intro_active:
		return

	if lbl_timer != null:
		if success:
			lbl_timer.text = "SUCCESS"
			lbl_timer.modulate = Color.GREEN
		else:
			lbl_timer.text = "FAILED"
			lbl_timer.modulate = Color.RED

	await get_tree().create_timer(
		2.0
	).timeout

	if not is_inside_tree():
		return

	_update_display()


func _on_preparation_phase_started() -> void:
	if lbl_quota_title != null:
		lbl_quota_title.text = "QUOTA"

	_update_display()


# -------------------------------------------------------------------
# CPS
# -------------------------------------------------------------------

func _on_cps_changed(
	new_cps: float
) -> void:
	_update_cps_display(new_cps)


func _update_cps_display(
	cps: float
) -> void:
	if lbl_cps == null:
		return

	lbl_cps.text = "CPS: %s" % _format_cps(cps)


func _format_cps(
	cps: float
) -> String:
	var integer_value: int = int(round(cps))

	if abs(cps - float(integer_value)) < 0.001:
		return str(integer_value)

	return "%.1f" % cps


# -------------------------------------------------------------------
# Сила клика
# -------------------------------------------------------------------

func _on_click_upgraded(
	_upgrade_type: String
) -> void:
	_update_click_power_display(
		_get_current_click_power()
	)


func _update_click_power_display(
	click_power: int
) -> void:
	if lbl_cost == null:
		return

	lbl_cost.text = "CLICK: %d" % click_power


func _get_current_click_power() -> int:
	if _shop_backend == null:
		return 1

	if not is_instance_valid(_shop_backend):
		return 1

	if _shop_backend.click_upgrade_data == null:
		return 1

	if _shop_backend.has_method(
		&"get_current_click_power"
	):
		var result: Variant = _shop_backend.call(
			&"get_current_click_power"
		)

		return maxi(
			int(result),
			1
		)

	return 1


# -------------------------------------------------------------------
# Полное обновление дисплея
# -------------------------------------------------------------------

func _update_display() -> void:
	if lbl_score_val != null:
		lbl_score_val.text = str(
			GameManager.score
		)

	_update_quota_display()

	if _factory_manager != null:
		_update_cps_display(
			_factory_manager.get_total_cps()
		)
	else:
		_update_cps_display(0.0)

	_update_click_power_display(
		_get_current_click_power()
	)


func _update_quota_display() -> void:
	if lbl_quota_val == null:
		return

	var quota_index: int = (
		QuotaManager.current_quota_index
	)

	if quota_index < QuotaManager.quotas.size():
		lbl_quota_val.text = str(
			QuotaManager.quotas[quota_index][1]
		)
	else:
		lbl_quota_val.text = "ALL DONE"
