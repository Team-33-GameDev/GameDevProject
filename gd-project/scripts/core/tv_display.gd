extends SubViewport

@export var eyes_screen: Control
@export var score_screen: Node

var lbl_score_title: Label
var lbl_score_val: Label
var lbl_quota_title: Label
var lbl_quota_val: Label
var lbl_timer: Label
var lbl_cps: Label
var lbl_cost: Label


func _ready() -> void:
	_find_labels()
	_setup_labels()
	
	if GameManager:
		GameManager.score_changed.connect(_on_score_changed)
	if QuotaManager:
		QuotaManager.timer_updated.connect(_on_timer_updated)
		QuotaManager.run_started.connect(_on_run_started)
		QuotaManager.run_ended.connect(_on_run_ended)
		QuotaManager.preparation_phase_started.connect(_on_preparation_phase_started)
	
	_show_eyes("PRESS THE BUTTON TO BEGIN")
	AudioManager.play_sfx("Evilai", 1.0)
	await get_tree().create_timer(20.0).timeout
	_show_main_screen()
	_update_display()

func _find_labels() -> void:
	if not score_screen:
		push_error("score_screen not assigned!")
		return
	
	lbl_score_title = score_screen.get_node_or_null("Score")
	lbl_score_val = score_screen.get_node_or_null("ScoreValue")
	lbl_quota_title = score_screen.get_node_or_null("Quota")
	lbl_quota_val = score_screen.get_node_or_null("QuotaValue")
	lbl_timer = score_screen.get_node_or_null("Timer")
	lbl_cps = score_screen.get_node_or_null("CPS")
	lbl_cost = score_screen.get_node_or_null("Cost")

func _setup_labels() -> void:
	for label in [lbl_score_title, lbl_score_val, lbl_quota_title, lbl_quota_val, lbl_timer, lbl_cps, lbl_cost]:
		if label:
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			label.pivot_offset = label.size / 2

func _show_eyes(msg: String = "") -> void:
	if eyes_screen: eyes_screen.visible = true
	if score_screen: score_screen.visible = false

func _show_main_screen() -> void:
	if eyes_screen: eyes_screen.visible = false
	if score_screen: score_screen.visible = true

func show_eyes_temporarily(duration: float = 3.0, message: String = "") -> void:
	_show_eyes(message)
	await get_tree().create_timer(duration).timeout
	_show_main_screen()

func _on_score_changed(new_score: int) -> void:
	if lbl_score_val: lbl_score_val.text = str(new_score)

func _on_timer_updated(time_left: float) -> void:
	if not lbl_timer: return
	var m = int(time_left / 60)
	var s = int(time_left) % 60
	lbl_timer.text = "%02d:%02d" % [m, s]
	lbl_timer.modulate = Color.RED if time_left <= 5.0 else Color.WHITE

func _on_run_started() -> void:
	_show_main_screen()

func _on_run_ended(success: bool) -> void:
	if lbl_timer:
		lbl_timer.text = "SUCCESS" if success else "FAILED"
		lbl_timer.modulate = Color.GREEN if success else Color.RED

func _on_preparation_phase_started() -> void:
	if lbl_quota_title: lbl_quota_title.text = "Quota"
	if lbl_score_val: lbl_score_val.text = str(GameManager.score)
	if lbl_quota_val and QuotaManager:
		var idx = QuotaManager.current_quota_index
		if idx < QuotaManager.quotas.size():
			lbl_quota_val.text = str(QuotaManager.quotas[idx][1])

func _update_display() -> void:
	if lbl_score_val: lbl_score_val.text = str(GameManager.score)
	if lbl_quota_val and QuotaManager:
		var idx = QuotaManager.current_quota_index
		if idx < QuotaManager.quotas.size():
			lbl_quota_val.text = str(QuotaManager.quotas[idx][1])
	if lbl_cps: lbl_cps.text = "CPS: 0"
	if lbl_cost: lbl_cost.text = "COST: 1"
