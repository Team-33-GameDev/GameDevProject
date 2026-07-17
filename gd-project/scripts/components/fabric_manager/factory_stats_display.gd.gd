extends Sprite3D
class_name FactoryStatsDisplay


@export var display_name: String = "FACTORY"

@export_range(0, 32, 1)
var factory_index: int = 0

@export_range(0.05, 1.0, 0.05)
var refresh_interval: float = 0.1


@onready var title_label: Label = \
	$SubViewport/Background/MarginContainer/VBoxContainer/Title

@onready var hp_label: Label = \
	$SubViewport/Background/MarginContainer/VBoxContainer/HP

@onready var cps_label: Label = \
	$SubViewport/Background/MarginContainer/VBoxContainer/CPS

@onready var dps_label: Label = \
	$SubViewport/Background/MarginContainer/VBoxContainer/DPS

@onready var restore_label: Label = \
	$SubViewport/Background/MarginContainer/VBoxContainer/Restore


var _factory_manager: FactoryManager
var _refresh_timer: Timer


func _ready() -> void:
	_create_refresh_timer()
	call_deferred("_refresh")


func _create_refresh_timer() -> void:
	_refresh_timer = Timer.new()
	_refresh_timer.name = "RefreshTimer"
	_refresh_timer.wait_time = refresh_interval
	_refresh_timer.one_shot = false

	_refresh_timer.timeout.connect(
		_refresh
	)

	add_child(_refresh_timer)
	_refresh_timer.start()


func _refresh() -> void:
	if not is_node_ready():
		return

	title_label.text = display_name.to_upper()

	if (
		_factory_manager == null
		or not is_instance_valid(
			_factory_manager
		)
	):
		_factory_manager = \
			_find_factory_manager()

	if _factory_manager == null:
		_set_unavailable()
		return

	var factory: Factory = \
		_factory_manager.get_factory(
			factory_index
		)

	if (
		factory == null
		or factory.data == null
	):
		_set_unavailable()
		return

	var data: AutoClickerData = factory.data

	hp_label.text = "HP: %d/%d" % [
		data.cur_hp,
		data.max_hp,
	]

	cps_label.text = "CPS: %s" % \
		_format_rate(
			_calculate_cps(data)
		)

	dps_label.text = "DPS: %s HP/SEC" % \
		_format_rate(
			_calculate_dps(data)
		)

	restore_label.text = \
		"RESTORE/CLICK: %d" % data.rhpt


func _find_factory_manager() -> FactoryManager:
	var manager_node: Node = \
		get_tree().get_first_node_in_group(
			"factory_manager"
		)

	if manager_node is FactoryManager:
		return manager_node as FactoryManager

	return null


func _calculate_cps(
	data: AutoClickerData
) -> float:
	if not _is_factory_contributing(data):
		return 0.0

	if _factory_manager.tick_interval <= 0.0:
		return 0.0

	var click_period: int = maxi(
		1,
		data.click_ticks_period
	)

	var seconds_per_click: float = (
		_factory_manager.tick_interval
		* float(click_period)
	)

	if seconds_per_click <= 0.0:
		return 0.0

	return (
		float(data.click_value)
		/ seconds_per_click
	)


func _calculate_dps(
	data: AutoClickerData
) -> float:
	if not _is_factory_contributing(data):
		return 0.0

	# Никаких вычислений через период тиков.
	# Показываем значение, заданное в ресурсе фабрики.
	return data.get_dps(
		_factory_manager.tick_interval
	)


func _is_factory_contributing(
	data: AutoClickerData
) -> bool:
	return (
		data.is_purchased
		and data.is_alive()
		and not data.is_factory_pause
	)


func _format_rate(
	value: float
) -> String:
	var rounded_value: float = roundf(value)

	if is_equal_approx(
		value,
		rounded_value
	):
		return str(
			int(rounded_value)
		)

	return "%.1f" % value


func _set_unavailable() -> void:
	title_label.text = display_name.to_upper()
	hp_label.text = "HP: --/--"
	cps_label.text = "CPS: --"
	dps_label.text = "DPS: -- HP/SEC"
	restore_label.text = "RESTORE/CLICK: --"
