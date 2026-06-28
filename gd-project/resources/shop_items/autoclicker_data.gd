extends ShopItemData
class_name AutoClickerData

@export var click_value: int = 1
@export var click_period: float = 0.5
@export var max_hp: int = 100
@export var damage: int = 1
@export var damage_period: float = 0.5
@export var rhpc: int = 5

@export var upgrade_base_price: int = 50
@export var upgrade_price_multiplier: float = 1.5

var upgrade_level_click: int = 0
var upgrade_level_hp: int = 0
var upgrade_level_damage: int = 0
var upgrade_level_damage_period: int = 0
var upgrade_level_rhpc: int = 0

func _get_upgrade_price(level: int) -> int:
	return int(upgrade_base_price * pow(upgrade_price_multiplier, level))

func get_click_upgrade_price() -> int:
	return _get_upgrade_price(upgrade_level_click)

func get_hp_upgrade_price() -> int:
	return _get_upgrade_price(upgrade_level_hp)

func get_damage_upgrade_price() -> int:
	return _get_upgrade_price(upgrade_level_damage)

func get_damage_period_upgrade_price() -> int:
	return _get_upgrade_price(upgrade_level_damage_period)

func get_rhpc_upgrade_price() -> int:
	return _get_upgrade_price(upgrade_level_rhpc)

func upgrade_click_value(bonus: int = 1) -> int:
	click_value += bonus
	upgrade_level_click += 1
	return click_value

func upgrade_max_hp(bonus: int = 10) -> int:
	max_hp += bonus
	upgrade_level_hp += 1
	return max_hp

func upgrade_damage(bonus: int = 1) -> int:
	damage += bonus
	upgrade_level_damage += 1
	return damage

func upgrade_damage_period(multiplier: float = 0.9) -> float:
	damage_period *= multiplier
	upgrade_level_damage_period += 1
	return damage_period

func upgrade_rhpc(bonus: int = 2) -> int:
	rhpc += bonus
	upgrade_level_rhpc += 1
	return rhpc

func duplicate_data() -> AutoClickerData:
	var new_data = AutoClickerData.new()
	new_data.item_name = item_name
	new_data.description = description
	new_data.price = price
	new_data.click_value = click_value
	new_data.click_period = click_period
	new_data.max_hp = max_hp
	new_data.damage = damage
	new_data.damage_period = damage_period
	new_data.rhpc = rhpc
	new_data.upgrade_base_price = upgrade_base_price
	new_data.upgrade_price_multiplier = upgrade_price_multiplier
	new_data.upgrade_level_click = upgrade_level_click
	new_data.upgrade_level_hp = upgrade_level_hp
	new_data.upgrade_level_damage = upgrade_level_damage
	new_data.upgrade_level_damage_period = upgrade_level_damage_period
	new_data.upgrade_level_rhpc = upgrade_level_rhpc
	return new_data
