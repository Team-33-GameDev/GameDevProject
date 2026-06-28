extends Node3D
class_name Shop
signal click

func _ready() -> void:
	click.connect(_on_click)


# CLICK ========================================================================
@export var click_upgrade_data: ClickUpgradeData

signal click_upgraded(upgrade_type: String)
func _on_click():
	if click_upgrade_data:
		var power = click_upgrade_data.calculate_click()
		#print(power)
		GameManager.click(power)
	else:
		GameManager.click(1)
func upgrade_click_add() -> bool:
	if click_upgrade_data == null: return false
	var price = click_upgrade_data.get_add_price()
	if not GameManager.has_score(price): return false
	click_upgrade_data.upgrade_add()
	GameManager.spend_score(price)
	click_upgraded.emit("add")
	return true

func get_click_add_level() -> int:
	return click_upgrade_data.add_level if click_upgrade_data else -1

func get_click_add_price() -> int:
	return click_upgrade_data.get_add_price() if click_upgrade_data else -1

func upgrade_click_mult() -> bool:
	if click_upgrade_data == null: return false
	var price = click_upgrade_data.get_mult_price()
	if not GameManager.has_score(price): return false
	click_upgrade_data.upgrade_mult()
	GameManager.spend_score(price)
	click_upgraded.emit("mult")
	return true

func get_click_mult_level() -> int:
	return click_upgrade_data.mult_level if click_upgrade_data else -1

func get_click_mult_price() -> int:
	return click_upgrade_data.get_mult_price() if click_upgrade_data else -1

func upgrade_click_percent() -> bool:
	if click_upgrade_data == null: return false
	var price = click_upgrade_data.get_percent_price()
	if not GameManager.has_score(price): return false
	click_upgrade_data.upgrade_percent()
	GameManager.spend_score(price)
	click_upgraded.emit("percent")
	return true

func get_click_percent_level() -> int:
	return click_upgrade_data.percent_level if click_upgrade_data else -1

func get_click_percent_price() -> int:
	return click_upgrade_data.get_percent_price() if click_upgrade_data else -1

func upgrade_click_crit() -> bool:
	if click_upgrade_data == null: return false
	var price = click_upgrade_data.get_crit_price()
	if not GameManager.has_score(price): return false
	click_upgrade_data.upgrade_crit()
	GameManager.spend_score(price)
	click_upgraded.emit("crit")
	return true

func get_click_crit_level() -> int:
	return click_upgrade_data.crit_level if click_upgrade_data else -1

func get_click_crit_price() -> int:
	return click_upgrade_data.get_crit_price() if click_upgrade_data else -1

func get_current_click_power() -> int:
	if click_upgrade_data == null: return 0
	return click_upgrade_data.calculate_click_preview()

# CLICK ========================================================================


# FACTORY ======================================================================
@export var available_factories: Array[AutoClickerData]
var bought_factories: Array[Factory] = []

signal factory_purchased(factory: Factory)
signal factory_upgraded(factory: Factory, upgrade_type: String)

func buy_factory(index: int) -> bool:
	if index < 0 or index >= available_factories.size():
		return false
	var template = available_factories[index]
	if not GameManager.has_score(template.price):
		return false
	var new_data = template.duplicate_data()
	var factory = Factory.new()
	factory.data = new_data
	add_child(factory)
	bought_factories.append(factory)
	GameManager.spend_score(template.price)
	factory_purchased.emit(factory)
	return true

func _validate_index(index: int) -> bool:
	return index >= 0 and index < bought_factories.size()

func _get_data(index: int):
	if not _validate_index(index):
		return null
	return bought_factories[index].data




# Click Upgrade Here 
func upgrade_factory_click(factory_index: int) -> bool:
	var data = _get_data(factory_index)
	if not data: return false
	var price = data.get_click_upgrade_price()
	if not GameManager.has_score(price): return false
	data.upgrade_click_value()
	GameManager.spend_score(price)
	factory_upgraded.emit(bought_factories[factory_index], "click")
	return true

func get_click_upgrade_price(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.get_click_upgrade_price() if data else -1

func get_click_level(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.upgrade_level_click if data else -1



# Factory HP Upgrade Here 
func upgrade_factory_hp(factory_index: int) -> bool:
	var data = _get_data(factory_index)
	if not data: return false
	var price = data.get_hp_upgrade_price()
	if not GameManager.has_score(price): return false
	data.upgrade_max_hp()
	GameManager.spend_score(price)
	factory_upgraded.emit(bought_factories[factory_index], "hp")
	return true

func get_hp_upgrade_price(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.get_hp_upgrade_price() if data else -1

func get_hp_level(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.upgrade_level_hp if data else -1

# Damage of the factory Upgrade Here 
func upgrade_factory_damage(factory_index: int) -> bool:
	var data = _get_data(factory_index)
	if not data: return false
	var price = data.get_damage_upgrade_price()
	if not GameManager.has_score(price): return false
	data.upgrade_damage()
	GameManager.spend_score(price)
	factory_upgraded.emit(bought_factories[factory_index], "damage")
	return true

func get_damage_upgrade_price(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.get_damage_upgrade_price() if data else -1

func get_damage_level(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.upgrade_level_damage if data else -1




# Damage Period of the factory Upgrade Here 
func upgrade_factory_damage_period(factory_index: int) -> bool:
	var data = _get_data(factory_index)
	if not data: return false
	var price = data.get_damage_period_upgrade_price()
	if not GameManager.has_score(price): return false
	data.upgrade_damage_period()
	GameManager.spend_score(price)
	factory_upgraded.emit(bought_factories[factory_index], "damage_period")
	return true

func get_damage_period_upgrade_price(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.get_damage_period_upgrade_price() if data else -1

func get_damage_period_level(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.upgrade_level_damage_period if data else -1

# Fixing Factory upgrade, +HP per click 
func upgrade_factory_rhpc(factory_index: int) -> bool:
	var data = _get_data(factory_index)
	if not data: return false
	var price = data.get_rhpc_upgrade_price()
	if not GameManager.has_score(price): return false
	data.upgrade_rhpc()
	GameManager.spend_score(price)
	factory_upgraded.emit(bought_factories[factory_index], "rhpc")
	return true

func get_rhpc_upgrade_price(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.get_rhpc_upgrade_price() if data else -1

func get_rhpc_level(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.upgrade_level_rhpc if data else -1



# For UI in the future 
func get_click_value(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.click_value if data else -1

func get_click_period(factory_index: int) -> float:
	var data = _get_data(factory_index)
	return data.click_period if data else -1.0

func get_max_hp(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.max_hp if data else -1

func get_damage_value(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.damage if data else -1

func get_damage_period_value(factory_index: int) -> float:
	var data = _get_data(factory_index)
	return data.damage_period if data else -1.0

func get_rhpc_value(factory_index: int) -> int:
	var data = _get_data(factory_index)
	return data.rhpc if data else -1
	
# FACTORY ======================================================================
