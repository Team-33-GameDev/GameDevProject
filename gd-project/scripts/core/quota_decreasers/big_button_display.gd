extends Sprite3D
class_name BigButtonDisplay


@export_range(1, 100, 1)
var decrease_percent: int = 5

@export_range(1, 20, 1)
var required_jumps: int = 3


@onready var quota_value: Label = (
	$SubViewport
	/Background
	/Margin
	/VBox
	/QuotaValue
)

@onready var effect_label: Label = (
	$SubViewport
	/Background
	/Margin
	/VBox
	/Effect
)

@onready var jump_label: Label = (
	$SubViewport
	/Background
	/Margin
	/VBox
	/JumpProgress
)

@onready var progress_bar: ProgressBar = (
	$SubViewport
	/Background
	/Margin
	/VBox
	/JumpProgressBar
)


var _jump_count: int = 0
var _current_quota: int = 0


func _ready() -> void:
	_current_quota = _read_current_quota()

	progress_bar.min_value = 0.0
	progress_bar.max_value = float(required_jumps)

	if not QuotaManager.quota_updated.is_connected(
		_on_quota_updated
	):
		QuotaManager.quota_updated.connect(
			_on_quota_updated
		)

	if not QuotaManager.run_started.is_connected(
		_on_run_started
	):
		QuotaManager.run_started.connect(
			_on_run_started
		)

	if not QuotaManager.preparation_phase_started.is_connected(
		_on_preparation_phase_started
	):
		QuotaManager.preparation_phase_started.connect(
			_on_preparation_phase_started
		)

	_refresh()


func _exit_tree() -> void:
	if QuotaManager.quota_updated.is_connected(
		_on_quota_updated
	):
		QuotaManager.quota_updated.disconnect(
			_on_quota_updated
		)

	if QuotaManager.run_started.is_connected(
		_on_run_started
	):
		QuotaManager.run_started.disconnect(
			_on_run_started
		)

	if QuotaManager.preparation_phase_started.is_connected(
		_on_preparation_phase_started
	):
		QuotaManager.preparation_phase_started.disconnect(
			_on_preparation_phase_started
		)


func register_jump() -> void:
	_jump_count += 1

	if _jump_count >= required_jumps:
		_jump_count = 0

	_refresh_progress()


func _on_quota_updated(
	new_quota: int
) -> void:
	_current_quota = new_quota
	_refresh_quota()


func _on_run_started() -> void:
	_reset_display()


func _on_preparation_phase_started() -> void:
	_reset_display()


func _reset_display() -> void:
	_jump_count = 0
	_current_quota = _read_current_quota()

	_refresh()


func _refresh() -> void:
	effect_label.text = "-%d%% AFTER %d JUMPS" % [
		decrease_percent,
		required_jumps
	]

	_refresh_quota()
	_refresh_progress()


func _refresh_quota() -> void:
	quota_value.text = _format_number(
		_current_quota
	)


func _refresh_progress() -> void:
	jump_label.text = "JUMPS: %d / %d" % [
		_jump_count,
		required_jumps
	]

	progress_bar.value = float(
		_jump_count
	)


func _read_current_quota() -> int:
	if QuotaManager.current_quota_target > 0:
		return QuotaManager.current_quota_target

	var quota_index: int = (
		QuotaManager.current_quota_index
	)

	if (
		quota_index >= 0
		and quota_index < QuotaManager.quotas.size()
	):
		return int(
			QuotaManager.quotas[quota_index][1]
		)

	return 0


func _format_number(
	value: int
) -> String:
	var source: String = str(value)
	var result: String = ""

	while source.length() > 3:
		result = "," + source.right(3) + result
		source = source.left(
			source.length() - 3
		)

	return source + result
