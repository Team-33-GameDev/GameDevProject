extends Node3D
class_name FactoryManager


@export_range(0.001, 10.0, 0.001)
var tick_interval: float = 0.01


signal factory_updated(factory: Factory)
signal cps_changed(new_cps: float)


var timer: Timer

var all_factories: Array[Factory] = []
var active_factories: Array[Factory] = []

var _last_reported_cps: float = -1.0


func _enter_tree() -> void:
	add_to_group("factory_manager")


func _ready() -> void:
	# Никакой отладочной выдачи score здесь больше нет.
	#GameManager.add_score(10000000000)
	_discover_factories()
	_connect_factory_signals()
	_create_timer()

	_emit_cps_if_changed(true)


# -------------------------------------------------------------------
# Поиск фабрик
# -------------------------------------------------------------------

func _discover_factories() -> void:
	all_factories.clear()
	active_factories.clear()

	# Индексы определяются порядком непосредственных
	# дочерних Factory в factory_manager.tscn.
	for child in get_children():
		if child is not Factory:
			continue

		var factory := child as Factory

		factory.index = all_factories.size()
		all_factories.append(factory)

		if (
			factory.data != null
			and factory.data.is_purchased
		):
			active_factories.append(factory)

	print(
		"FactoryManager: Discovered %d factories."
		% all_factories.size()
	)


func _connect_factory_signals() -> void:
	for factory in all_factories:
		if not factory.request_buy_factory.is_connected(
			_on_factory_request_buy
		):
			factory.request_buy_factory.connect(
				_on_factory_request_buy
			)

		if not factory.request_upgrade_click.is_connected(
			_on_factory_request_upgrade_click
		):
			factory.request_upgrade_click.connect(
				_on_factory_request_upgrade_click
			)

		if not factory.request_upgrade_hp.is_connected(
			_on_factory_request_upgrade_hp
		):
			factory.request_upgrade_hp.connect(
				_on_factory_request_upgrade_hp
			)

		if not factory.request_upgrade_damage.is_connected(
			_on_factory_request_upgrade_damage
		):
			factory.request_upgrade_damage.connect(
				_on_factory_request_upgrade_damage
			)

		if not factory.request_upgrade_damage_period.is_connected(
			_on_factory_request_upgrade_damage_period
		):
			factory.request_upgrade_damage_period.connect(
				_on_factory_request_upgrade_damage_period
			)

		if not factory.request_upgrade_rhpt.is_connected(
			_on_factory_request_upgrade_rhpt
		):
			factory.request_upgrade_rhpt.connect(
				_on_factory_request_upgrade_rhpt
			)


# -------------------------------------------------------------------
# Рабочий таймер фабрик
# -------------------------------------------------------------------

func _create_timer() -> void:
	timer = Timer.new()
	timer.name = "FactoryTickTimer"
	timer.wait_time = maxf(tick_interval, 0.001)
	timer.one_shot = false

	timer.timeout.connect(_on_timer_timeout)

	add_child(timer)
	timer.start()


func _on_timer_timeout() -> void:
	# Во время подготовки фабрики полностью заморожены:
	# не начисляют очки, не получают урон и не двигают
	# внутренние счётчики производственного цикла.
	if (
		QuotaManager.current_state
		!= QuotaManager.GameState.RUNNING
	):
		# CPS продолжает рассчитываться по сохранённым
		# характеристикам фабрик.
		_emit_cps_if_changed()
		return

	for factory in active_factories:
		if factory == null:
			continue

		if factory.is_active():
			factory.process_tick()

	# Учитывает покупку, улучшение, остановку
	# или уничтожение фабрики.
	_emit_cps_if_changed()


# -------------------------------------------------------------------
# Покупка фабрик
# -------------------------------------------------------------------

func buy_factory(index: int) -> bool:
	var factory := get_factory(index)

	if factory == null:
		push_error(
			"FactoryManager: invalid factory index %d."
			% index
		)
		return false

	if factory.data == null:
		push_error(
			"FactoryManager: factory data is null."
		)
		return false

	if factory.template_data == null:
		push_error(
			"FactoryManager: template data is null."
		)
		return false

	if factory.data.is_purchased:
		push_warning(
			"FactoryManager: factory is already purchased."
		)
		return false

	if not is_factory_unlocked(index):
		push_warning(
			"FactoryManager: factory is locked."
		)
		return false

	if not factory.template_data.can_buy:
		push_warning(
			"FactoryManager: factory cannot be bought."
		)
		return false

	var price: int = factory.template_data.item_price

	if not GameManager.has_score(price):
		push_warning(
			"FactoryManager: not enough score."
		)
		return false

	if not GameManager.spend_score(price):
		return false

	factory.data.is_purchased = true
	factory.data.init()

	if factory not in active_factories:
		active_factories.append(factory)

	factory_updated.emit(factory)
	_emit_cps_if_changed(true)

	print(
		"FactoryManager: purchased factory at index %d."
		% index
	)

	return true


func is_factory_unlocked(index: int) -> bool:
	if index < 0 or index >= all_factories.size():
		return false

	for previous_index in range(index):
		var previous_factory := all_factories[
			previous_index
		]

		if previous_factory.data == null:
			return false

		if not previous_factory.data.is_purchased:
			return false

	return true


# -------------------------------------------------------------------
# Получение фабрик
# -------------------------------------------------------------------

func get_all_factories() -> Array[Factory]:
	return all_factories


func get_active_factories() -> Array[Factory]:
	return active_factories


func get_factory(index: int) -> Factory:
	if index < 0 or index >= all_factories.size():
		return null

	return all_factories[index]


# -------------------------------------------------------------------
# CPS
# -------------------------------------------------------------------

func get_total_cps() -> float:
	if tick_interval <= 0.0:
		return 0.0

	var total_cps: float = 0.0

	for factory in active_factories:
		if factory == null or factory.data == null:
			continue

		var data: AutoClickerData = factory.data

		if not data.is_purchased:
			continue

		if not data.is_alive():
			continue

		if data.is_factory_pause:
			continue

		var safe_click_period := maxi(
			1,
			data.click_ticks_period
		)

		var click_interval_seconds: float = (
			tick_interval
			* float(safe_click_period)
		)

		if click_interval_seconds <= 0.0:
			continue

		total_cps += (
			float(data.click_value)
			/ click_interval_seconds
		)

	return total_cps


func _emit_cps_if_changed(
	force: bool = false
) -> void:
	var new_cps := get_total_cps()

	if (
		force
		or not is_equal_approx(
			new_cps,
			_last_reported_cps
		)
	):
		_last_reported_cps = new_cps
		cps_changed.emit(new_cps)


# -------------------------------------------------------------------
# Улучшения
# -------------------------------------------------------------------

func upgrade_click(index: int) -> bool:
	var factory := get_factory(index)

	if factory == null:
		return false

	var result := factory.upgrade_click()

	if result:
		factory_updated.emit(factory)
		_emit_cps_if_changed(true)

	return result


func upgrade_hp(index: int) -> bool:
	var factory := get_factory(index)

	if factory == null:
		return false

	var result := factory.upgrade_hp()

	if result:
		factory_updated.emit(factory)
		_emit_cps_if_changed(true)

	return result


func upgrade_damage(index: int) -> bool:
	var factory := get_factory(index)

	if factory == null:
		return false

	var result := factory.upgrade_damage()

	if result:
		factory_updated.emit(factory)
		_emit_cps_if_changed(true)

	return result


func upgrade_damage_period(index: int) -> bool:
	var factory := get_factory(index)

	if factory == null:
		return false

	var result := factory.upgrade_damage_period()

	if result:
		factory_updated.emit(factory)
		_emit_cps_if_changed(true)

	return result


func upgrade_rhpt(index: int) -> bool:
	var factory := get_factory(index)

	if factory == null:
		return false

	var result := factory.upgrade_rhpt()

	if result:
		factory_updated.emit(factory)
		_emit_cps_if_changed(true)

	return result


# -------------------------------------------------------------------
# Старые физические сигналы
# -------------------------------------------------------------------

func _on_factory_request_buy(index: int) -> void:
	buy_factory(index)


func _on_factory_request_upgrade_click(
	index: int
) -> void:
	upgrade_click(index)


func _on_factory_request_upgrade_hp(
	index: int
) -> void:
	upgrade_hp(index)


func _on_factory_request_upgrade_damage(
	index: int
) -> void:
	upgrade_damage(index)


func _on_factory_request_upgrade_damage_period(
	index: int
) -> void:
	upgrade_damage_period(index)


func _on_factory_request_upgrade_rhpt(
	index: int
) -> void:
	upgrade_rhpt(index)


# -------------------------------------------------------------------
# Сохранение состояния фабрик
# -------------------------------------------------------------------

func get_save_data() -> Array:
	var data_list: Array = []

	for factory in all_factories:
		if (
			factory.data != null
			and factory.data.is_purchased
		):
			data_list.append(
				factory.get_data_copy()
			)
		else:
			data_list.append(null)

	return data_list


func restore_from_save_data(
	saved_data: Array
) -> void:
	for index in range(saved_data.size()):
		if index >= all_factories.size():
			break

		if saved_data[index] == null:
			continue

		var factory := all_factories[index]

		factory.restore_from_data(
			saved_data[index]
		)

		factory.data.is_purchased = true

		if factory not in active_factories:
			active_factories.append(factory)

		factory_updated.emit(factory)

	_emit_cps_if_changed(true)
