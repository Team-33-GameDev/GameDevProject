extends Node

@onready var timer_label: Label = $MarginContainer/VBoxContainer/TimerLabel
@onready var quota_label: Label = $MarginContainer/VBoxContainer/QuotaLabel
@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel

func _ready() -> void:
	# Настраиваем выравнивание для всех лейблов
	for label in [timer_label, quota_label, score_label]:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Подписываемся на сигналы QuotaManager
	QuotaManager.timer_updated.connect(_on_timer_updated)
	QuotaManager.quota_updated.connect(_on_quota_updated)
	QuotaManager.run_started.connect(_on_run_started)
	QuotaManager.run_ended.connect(_on_run_ended)
	QuotaManager.preparation_phase_started.connect(_on_preparation_phase_started)
	
	# Подписываемся на очки (из GameManager)
	GameManager.score_changed.connect(_on_score_changed)
	
	# Инициализируем начальные значения
	score_label.text = "SCORE: %d" % GameManager.score
	_set_idle_display()

func _on_timer_updated(time_left: float) -> void:
	# Форматируем в MM:SS
	var minutes = int(time_left / 60)
	var seconds = int(time_left) % 60
	timer_label.text = "TIME: %02d:%02d" % [minutes, seconds]
	
	# Мигание красным, когда осталось < 5 секунд
	if time_left <= 5.0:
		timer_label.modulate = Color.RED
	else:
		timer_label.modulate = Color.WHITE

func _on_quota_updated(target: int) -> void:
	quota_label.text = "QUOTA: %d" % target

func _on_score_changed(new_score: int) -> void:
	score_label.text = "SCORE: %d" % new_score
	_animate_bounce(score_label)

func _on_run_started() -> void:
	# Во время кликанья показываем таймер и текущую квоту
	timer_label.visible = true
	quota_label.visible = true
	score_label.visible = true
	timer_label.modulate = Color.WHITE

func _on_run_ended(success: bool) -> void:
	if success:
		timer_label.text = "SUCCESS"
		timer_label.modulate = Color.GREEN
		# Не показываем сразу NEXT QUOTA - ждем сигнала preparation_phase_started
	else:
		timer_label.text = "FAILED"
		timer_label.modulate = Color.RED
		quota_label.text = "QUOTA NOT MET"

func _on_preparation_phase_started() -> void:
	# Эта фаза наступает после успешного выполнения квоты
	_set_idle_display()

func _set_idle_display() -> void:
	# В фазе подготовки показываем только счет и следующую квоту
	timer_label.text = "--:--"
	timer_label.modulate = Color.WHITE
	
	if QuotaManager.current_quota_index < QuotaManager.quotas.size():
		var next_quota = QuotaManager.quotas[QuotaManager.current_quota_index][1]
		quota_label.text = "NEXT QUOTA: %d" % next_quota
	else:
		quota_label.text = "ALL QUOTAS COMPLETED!"

func _animate_bounce(label: Label) -> void:
	label.pivot_offset = label.size / 2
	
	# Создаем новый Tween для анимации
	var tween = create_tween()
	
	tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.05)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.15)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
