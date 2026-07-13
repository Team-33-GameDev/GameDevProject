extends Node3D
class_name FactoryManager
@export var tick_interval: float = 0.01
signal factory_updated(factory: Factory)

#static var instance: FactoryManager
#func _enter_tree() -> void:
	#if instance:
		#queue_free()
		#return
	#instance = self
#signal factory_tick(delta: float)
#signal factory_purchased(factory: Factory)
#signal factory_updated(factory: Factory)

var timer: Timer
var all_factories: Array[Factory] = []
var active_factories: Array[Factory] = []


func _ready() -> void:
	_discover_factories()
	_connect_factory_signals() 
	_create_timer()
	#buy_factory(0)
	#buy_factory(1)
	#buy_factory(2)

	
	
	#upgrade_click(0)
	#upgrade_click(0)
	#upgrade_click(0)
	
	#buy_factory(1)
	#buy_factory(2)

func _discover_factories() -> void:
	all_factories.clear()
	active_factories.clear()

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

func _create_timer() -> void:
	timer = Timer.new()
	timer.wait_time = tick_interval
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	#factory_tick.emit(tick_interval)
	for factory in active_factories:
		if factory.is_active():
			factory.process_tick()

func _connect_factory_signals() -> void:
	for factory in all_factories:
		factory.request_buy_factory.connect(_on_factory_request_buy)
		factory.request_upgrade_click.connect(_on_factory_request_upgrade_click)
		factory.request_upgrade_hp.connect(_on_factory_request_upgrade_hp)
		factory.request_upgrade_damage.connect(_on_factory_request_upgrade_damage)
		factory.request_upgrade_damage_period.connect(_on_factory_request_upgrade_damage_period)
		factory.request_upgrade_rhpt.connect(_on_factory_request_upgrade_rhpt)

func _on_factory_request_buy(index: int) -> void:
	buy_factory(index)

func _on_factory_request_upgrade_click(index: int) -> void:
	upgrade_click(index)

func _on_factory_request_upgrade_hp(index: int) -> void:
	upgrade_hp(index)

func _on_factory_request_upgrade_damage(index: int) -> void:
	upgrade_damage(index)

func _on_factory_request_upgrade_damage_period(index: int) -> void:
	upgrade_damage_period(index)

func _on_factory_request_upgrade_rhpt(index: int) -> void:
	upgrade_rhpt(index)


func buy_factory(index: int) -> bool:
	if index < 0 or index >= all_factories.size():
		push_error("FactoryManager: Invalid factory index.")
		return false

	var factory = all_factories[index]
	if not factory.data:
		push_error("FactoryManager: Factory data is null.")
		return false

	if factory.data.is_purchased:
		push_warning("FactoryManager: Factory already purchased.")
		return false

	if not is_factory_unlocked(index):
		push_warning("FactoryManager: Factory is locked.")
		return false

	if not factory.template_data.can_buy:
		push_warning("FactoryManager: Factory cannot be bought (can_buy = false).")
		return false

	var price = factory.template_data.item_price
	if not GameManager.has_score(price):
		push_warning("FactoryManager: Not enough score.")
		return false

	if not GameManager.spend_score(price):
		return false

	factory.data.is_purchased = true
	factory.data.init()

	active_factories.append(factory)
	factory_updated.emit(factory)

	#factory_purchased.emit(factory)
	#factory_updated.emit(factory)
	print("FactoryManager: Purchased factory at index %d." % index)
	return true

func is_factory_unlocked(index: int) -> bool:
	for i in range(index):
		if not all_factories[i].data or not all_factories[i].data.is_purchased:
			return false
	return true

func get_all_factories() -> Array[Factory]:
	return all_factories

func get_active_factories() -> Array[Factory]:
	return active_factories

func get_factory(index: int) -> Factory:
	if index < 0 or index >= all_factories.size():
		return null
	return all_factories[index]

func upgrade_click(index: int) -> bool:
	var factory = get_factory(index)
	if not factory:
		return false
	var result = factory.upgrade_click()
	if result:
		factory_updated.emit(factory)
	return result

func upgrade_hp(index: int) -> bool:
	var factory = get_factory(index)
	if not factory:
		return false
	var result = factory.upgrade_hp()
	if result:
		factory_updated.emit(factory)
	return result

func upgrade_damage(index: int) -> bool:
	var factory = get_factory(index)
	if not factory:
		return false
	var result = factory.upgrade_damage()
	if result:
		factory_updated.emit(factory)
	return result

func upgrade_damage_period(index: int) -> bool:
	var factory = get_factory(index)
	if not factory:
		return false
	var result = factory.upgrade_damage_period()
	if result:
		factory_updated.emit(factory)
	return result

func upgrade_rhpt(index: int) -> bool:
	var factory = get_factory(index)
	if not factory:
		return false
	var result = factory.upgrade_rhpt()
	if result:
		factory_updated.emit(factory)
	return result

func get_save_data() -> Array:
	var data_list = []
	for factory in all_factories:
		if factory.data and factory.data.is_purchased:
			data_list.append(factory.get_data_copy())
		else:
			data_list.append(null)
	return data_list

func restore_from_save_data(saved_data: Array) -> void:
	for i in range(saved_data.size()):
		if i >= all_factories.size():
			break
		var factory = all_factories[i]
		if saved_data[i] != null:
			factory.restore_from_data(saved_data[i])
			factory.data.is_purchased = true
			if factory not in active_factories:
				active_factories.append(factory)
			#factory_purchased.emit(factory)
