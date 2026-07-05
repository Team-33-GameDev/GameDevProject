extends ShopItemData
class_name AutoClickerData


@export_category("Start Value")
@export var click_value: int = 1
@export var click_ticks_period: int = 20
@export var cur_click_ticks: int = 0
@export var max_hp: int = 100
@export var rhpt: int = 5 # Restore HP per tick
@export var dmg: int = 1
@export var dmg_tick_period: int = 30
@export var cur_tick_dmg: int = 0
@export var is_factory_pause: bool = false 

@export_category("Upgrades Data")
@export var upg_base_price: int = 50
@export var upg_price_multiplier: float = 1.5

@export var bonus_click_value: int = 1
@export var bonus_max_hp: int = 1
@export var bonus_dmg: int = 1
@export var bonus_dmg_period: int = 1
@export var bonus_rhpt: int = 2
@export var max_lvl: int = 100



var cur_hp: int = max_hp


var upg_lvl_click: int = 0
var upg_lvl_hp: int = 0
var upg_lvl_dmg: int = 0
var upg_lvl_dmg_period: int = 0
var upg_lvl_rhpt: int = 0

func init() -> void:
	cur_hp = max_hp



func restore_hp() -> bool:
	if is_factory_pause or (cur_hp >= max_hp):
		return false
	cur_hp = min(max_hp, cur_hp + rhpt)
	return true

func is_alive() -> bool:
	return cur_hp > 0




func is_time_to_click():
	return (cur_click_ticks % click_ticks_period) == 0

func click() -> bool:
	if !(is_time_to_click()) or is_factory_pause or !is_alive():
		return false
	cur_click_ticks = 0
	GameManager.click(click_value)
	return true





func is_time_to_damage() -> bool:
	return (cur_tick_dmg % dmg_tick_period) == 0

func apply_dmg() -> bool:
	if !(is_time_to_damage()) or is_factory_pause or !is_alive():
		return false
	cur_hp = max(0, cur_hp - dmg)
	return true

#________UPGRADES

func is_upg_valid_(lvl: int) -> bool:
	return (max_lvl > lvl) and GameManager.has_score(_get_upg_price(lvl))


func upg_click_value() -> int:
	if !is_upg_valid_(upg_lvl_click):
		return false
	spend_score(_get_upg_price(upg_lvl_click))
	
	click_value += bonus_click_value
	upg_lvl_click += 1
	return click_value

func upg_max_hp() -> int:
	if !is_upg_valid_(upg_lvl_hp):
		return false
	spend_score(_get_upg_price(upg_lvl_hp))
	
	max_hp += bonus_max_hp
	upg_lvl_hp += 1
	cur_hp += bonus_max_hp
	return max_hp

func upg_dmg() -> int:
	if !is_upg_valid_(upg_lvl_dmg):
		return false
	spend_score(_get_upg_price(upg_lvl_dmg))
	
	dmg += bonus_dmg
	upg_lvl_dmg += 1
	return dmg

func upg_dmg_period() -> float:
	if !is_upg_valid_(upg_lvl_dmg_period):
		return false
	spend_score(_get_upg_price(upg_lvl_dmg_period))
	
	dmg_tick_period -= bonus_dmg_period
	upg_lvl_dmg_period += 1
	return dmg_tick_period

func upg_rhpt() -> int:
	if !is_upg_valid_(upg_lvl_rhpt):
		return false
	spend_score(_get_upg_price(upg_lvl_rhpt))
	
	rhpt += bonus_rhpt
	upg_lvl_rhpt += 1
	return rhpt




#________GETTERS
func get_hp_percent() -> float:
	if max_hp == 0:
		return 0.0
	return (float(cur_hp) / float(max_hp)) * 100.0

func _get_upg_price(lvl: int) -> int:
	return int(upg_base_price * pow(upg_price_multiplier, lvl))

func get_click_upg_price() -> int:
	return _get_upg_price(upg_lvl_click)

func get_hp_upg_price() -> int:
	return _get_upg_price(upg_lvl_hp)

func get_dmg_upg_price() -> int:
	return _get_upg_price(upg_lvl_dmg)

func get_dmg_period_upg_price() -> int:
	return _get_upg_price(upg_lvl_dmg_period)

func get_rhpt_upg_price() -> int:
	return _get_upg_price(upg_lvl_rhpt)






func duplicate_data() -> AutoClickerData:
	var new_data = AutoClickerData.new()
	new_data.click_value = click_value
	new_data.click_ticks_period = click_ticks_period
	new_data.cur_click_ticks = cur_click_ticks
	new_data.max_hp = max_hp
	new_data.rhpt = rhpt
	new_data.dmg = dmg
	new_data.dmg_tick_period = dmg_tick_period
	new_data.cur_tick_dmg = cur_tick_dmg
	new_data.is_factory_pause = is_factory_pause

	new_data.upg_base_price = upg_base_price
	new_data.upg_price_multiplier = upg_price_multiplier

	new_data.bonus_click_value = bonus_click_value
	new_data.bonus_max_hp = bonus_max_hp
	new_data.bonus_dmg = bonus_dmg
	new_data.bonus_dmg_period = bonus_dmg_period
	new_data.bonus_rhpt = bonus_rhpt
	new_data.max_lvl = max_lvl



	new_data.cur_hp = cur_hp


	new_data.upg_lvl_click = upg_lvl_click
	new_data.upg_lvl_hp = upg_lvl_hp
	new_data.upg_lvl_dmg = upg_lvl_dmg
	new_data.upg_lvl_dmg_period = upg_lvl_dmg_period
	new_data.upg_lvl_rhpt = upg_lvl_rhpt

	return new_data
