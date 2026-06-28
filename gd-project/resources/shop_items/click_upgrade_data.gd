extends ShopItemData
class_name ClickUpgradeData

@export var base_click_power: int = 1
var total_clicks: int = 0

@export_group("Additive Upgrade")
@export var add_bonus_per_level: int = 1
@export var add_price_base: int = 10
@export var add_price_mult: float = 1.5
var add_level: int = 0

@export_group("Multiplicative Upgrade")
@export var mult_bonus_per_level: float = 2.0
@export var mult_price_base: int = 20
@export var mult_price_mult: float = 2.0
var mult_level: int = 0

@export_group("Percent Upgrade")
@export var percent_bonus_per_level: float = 0.05
@export var percent_price_base: int = 30
@export var percent_price_mult: float = 2.5
var percent_level: int = 0

@export_group("Critical Upgrade")
@export var crit_chance_per_level: float = 0.05
@export var crit_multiplier: float = 2.0
@export var crit_price_base: int = 50
@export var crit_price_mult: float = 3.0
var crit_level: int = 0

func _get_price(base: int, mult: float, level: int) -> int:
	return int(base * pow(mult, level))

func get_add_price() -> int:
	return _get_price(add_price_base, add_price_mult, add_level)

func get_mult_price() -> int:
	return _get_price(mult_price_base, mult_price_mult, mult_level)

func get_percent_price() -> int:
	return _get_price(percent_price_base, percent_price_mult, percent_level)

func get_crit_price() -> int:
	return _get_price(crit_price_base, crit_price_mult, crit_level)

func upgrade_add() -> void:
	add_level += 1

func upgrade_mult() -> void:
	mult_level += 1

func upgrade_percent() -> void:
	percent_level += 1

func upgrade_crit() -> void:
	crit_level += 1

func calculate_click() -> int:
	var power = base_click_power
	power += add_level * add_bonus_per_level
	var percent_bonus = total_clicks * (percent_level * percent_bonus_per_level)
	power += int(percent_bonus)
	power = int(power * (pow(mult_bonus_per_level,mult_level) ))
	#print("mult_level*mult_bonus_per_level: ", pow(mult_bonus_per_level,mult_level))
	var crit_chance = crit_level * crit_chance_per_level
	if randf() < crit_chance:
		power = int(power * crit_multiplier)
	total_clicks += 1
	
	return power

func calculate_click_preview() -> int:
	var power = base_click_power
	power += add_level * add_bonus_per_level
	var percent_bonus = total_clicks * (percent_level * percent_bonus_per_level)
	power += int(percent_bonus)
	power = int(power * (pow(mult_bonus_per_level,mult_level) ))


	
	var crit_chance = crit_level * crit_chance_per_level
	if randf() < crit_chance:
		power = int(power * crit_multiplier)
	return power

func duplicate_data() -> ClickUpgradeData:
	var new = ClickUpgradeData.new()
	new.item_name = item_name
	new.description = description
	new.price = price
	# Копируем собственные поля
	new.base_click_power = base_click_power
	new.total_clicks = total_clicks
	new.add_bonus_per_level = add_bonus_per_level
	new.add_price_base = add_price_base
	new.add_price_mult = add_price_mult
	new.add_level = add_level
	new.mult_bonus_per_level = mult_bonus_per_level
	new.mult_price_base = mult_price_base
	new.mult_price_mult = mult_price_mult
	new.mult_level = mult_level
	new.percent_bonus_per_level = percent_bonus_per_level
	new.percent_price_base = percent_price_base
	new.percent_price_mult = percent_price_mult
	new.percent_level = percent_level
	new.crit_chance_per_level = crit_chance_per_level
	new.crit_multiplier = crit_multiplier
	new.crit_price_base = crit_price_base
	new.crit_price_mult = crit_price_mult
	new.crit_level = crit_level
	return new
