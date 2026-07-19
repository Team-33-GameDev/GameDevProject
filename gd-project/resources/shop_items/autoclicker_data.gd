extends ShopItemData
class_name AutoClickerData


const MIN_DPS: float = 1.0
const FACTORY_WEAR_MULTIPLIER: int = 2


@export_category("Start Value")
@export var click_value: int = 1
@export var click_ticks_period: int = 20
@export var cur_click_ticks: int = 0

@export var max_hp: int = 100
@export var rhpt: int = 5

# Фактический урон, который apply_dmg() снимает за одно срабатывание.
@export var dmg: int = 1

# Текущее значение, показываемое на экране.
@export var dps: float = 1.0

# Базовое значение урона в секунду для отображения и сохранений.
@export var base_dps: float = 1.0

@export var dmg_tick_period: int = 30

@export var cur_tick_dmg: int = 0
@export var is_factory_pause: bool = false


@export_category("Upgrades Data")
@export var upg_price_multiplier: float = 1.75

@export var bonus_max_hp: int = 1
@export var ubp_max_hp: int = 100

@export var bonus_click_value: int = 1
@export var ubp_click_value: int = 100

# Оставлено для совместимости с существующими .tres-ресурсами.
@export var bonus_dmg: int = -1
@export var ubp_dmg: int = 100

@export var bonus_dmg_period: int = 1
@export var ubp_dmg_period: int = 100

@export var bonus_rhpt: int = 2
@export var ubp_rhpt: int = 100

@export var max_lvl: int = 100


var cur_hp: int = max_hp

var upg_lvl_hp: int = 0
var upg_lvl_click: int = 0
var upg_lvl_dmg: int = 0
var upg_lvl_dmg_period: int = 0
var upg_lvl_rhpt: int = 0

var cur_price_hp: int = ubp_max_hp
var cur_price_click: int = ubp_click_value
var cur_price_dmg: int = ubp_dmg
var cur_price_dmg_period: int = ubp_dmg_period
var cur_price_rhpt: int = ubp_rhpt


func init() -> void:
	cur_hp = max_hp

	cur_price_click = ubp_click_value
	cur_price_hp = ubp_max_hp
	cur_price_dmg = ubp_dmg
	cur_price_dmg_period = ubp_dmg_period
	cur_price_rhpt = ubp_rhpt

	dps = maxf(
	MIN_DPS,
	dps
	)

	base_dps = maxf(
		MIN_DPS,
		base_dps
	)


func restore_hp() -> bool:
	if cur_hp >= max_hp:
		return false

	cur_hp = mini(
		max_hp,
		cur_hp + rhpt
	)

	return true


func is_alive() -> bool:
	return cur_hp > 0


func is_time_to_click() -> bool:
	return (
		cur_click_ticks
		% maxi(1, click_ticks_period)
	) == 0


func click() -> bool:
	if (
		not is_time_to_click()
		or is_factory_pause
		or not is_alive()
	):
		return false

	cur_click_ticks = 0

	if (
		QuotaManager.current_state
		!= QuotaManager.GameState.RUNNING
	):
		return false

	GameManager.add_score(click_value)

	return true


func is_time_to_damage() -> bool:
	return (
		cur_tick_dmg
		% maxi(1, dmg_tick_period)
	) == 0


func apply_dmg() -> bool:
	if (
		not is_time_to_damage()
		or is_factory_pause
		or not is_alive()
	):
		return false

	cur_tick_dmg = 0
	# The campaign is deliberately more maintenance-heavy: every wear
	# event removes twice the configured base damage. Keeping the
	# multiplier here makes all six factories follow the same rule and
	# preserves the relative balance of their resource values.
	cur_hp = maxi(
		0,
		cur_hp - dmg * FACTORY_WEAR_MULTIPLIER
	)

	return true


func is_upg_valid_(
	lvl: int,
	price: int
) -> bool:
	return (
		max_lvl > lvl
		and GameManager.has_score(price)
	)


# UPGRADES METHODS

func get_dps(
	tick_interval: float
) -> float:
	if tick_interval <= 0.0:
		return 0.0

	var damage_interval: float = (
		tick_interval
		* float(maxi(1, dmg_tick_period))
	)

	return float(dmg) / damage_interval


## Исправляет некорректные значения из старых данных.
##
## tick_interval оставлен в сигнатуре для совместимости.
func normalize_dps(
	tick_interval: float
) -> void:
	dmg = maxi(1, dmg)
	dmg_tick_period = maxi(1, dmg_tick_period)
	dps = get_dps(tick_interval)
	base_dps = dps


func upg_click_value() -> int:
	if not is_upg_valid_(
		upg_lvl_click,
		cur_price_click
	):
		return false

	spend_score(cur_price_click)

	click_value += bonus_click_value

	upg_lvl_click += 1

	cur_price_click = int(
		cur_price_click
		* upg_price_multiplier
	)

	return click_value


func upg_max_hp() -> int:
	if not is_upg_valid_(
		upg_lvl_hp,
		cur_price_hp
	):
		return false

	spend_score(cur_price_hp)

	max_hp += bonus_max_hp
	cur_hp += bonus_max_hp

	upg_lvl_hp += 1

	cur_price_hp = int(
		cur_price_hp
		* upg_price_multiplier
	)

	return max_hp


func upg_dmg(
	tick_interval: float
) -> float:
	if dmg <= 1:
		return 0.0

	if not is_upg_valid_(
		upg_lvl_dmg,
		cur_price_dmg
	):
		return 0.0

	var damage_reduction: int = maxi(
		1,
		absi(bonus_dmg)
	)

	var next_dmg: int = maxi(
		1,
		dmg - damage_reduction
	)

	spend_score(cur_price_dmg)

	dmg = next_dmg
	dps = get_dps(tick_interval)
	upg_lvl_dmg += 1

	cur_price_dmg = int(
		cur_price_dmg
		* upg_price_multiplier
	)

	return dps


func upg_dmg_period() -> float:
	if not is_upg_valid_(
		upg_lvl_dmg_period,
		cur_price_dmg_period
	):
		return false

	spend_score(cur_price_dmg_period)

	dmg_tick_period += maxi(
		1,
		bonus_dmg_period
	)

	upg_lvl_dmg_period += 1

	cur_price_dmg_period = int(
		cur_price_dmg_period
		* upg_price_multiplier
	)

	return dmg_tick_period


func upg_rhpt() -> int:
	if not is_upg_valid_(
		upg_lvl_rhpt,
		cur_price_rhpt
	):
		return false

	spend_score(cur_price_rhpt)

	rhpt += bonus_rhpt
	upg_lvl_rhpt += 1

	cur_price_rhpt = int(
		cur_price_rhpt
		* upg_price_multiplier
	)

	return rhpt


func get_hp_percent() -> float:
	if max_hp == 0:
		return 0.0

	return (
		float(cur_hp)
		/ float(max_hp)
	) * 100.0


func get_click_upg_price() -> int:
	return cur_price_click


func get_hp_upg_price() -> int:
	return cur_price_hp


func get_dmg_upg_price() -> int:
	return cur_price_dmg


func get_dmg_period_upg_price() -> int:
	return cur_price_dmg_period


func get_rhpt_upg_price() -> int:
	return cur_price_rhpt


func duplicate_data() -> AutoClickerData:
	var new_data := AutoClickerData.new()

	new_data.click_value = click_value
	new_data.click_ticks_period = click_ticks_period
	new_data.cur_click_ticks = cur_click_ticks

	new_data.max_hp = max_hp
	new_data.rhpt = rhpt

	new_data.dmg = dmg
	new_data.dps = dps
	new_data.base_dps = base_dps

	new_data.dmg_tick_period = dmg_tick_period
	new_data.cur_tick_dmg = cur_tick_dmg
	new_data.is_factory_pause = is_factory_pause

	new_data.upg_price_multiplier = upg_price_multiplier

	new_data.bonus_click_value = bonus_click_value
	new_data.ubp_click_value = ubp_click_value

	new_data.bonus_max_hp = bonus_max_hp
	new_data.ubp_max_hp = ubp_max_hp

	new_data.bonus_dmg = bonus_dmg
	new_data.ubp_dmg = ubp_dmg

	new_data.bonus_dmg_period = bonus_dmg_period
	new_data.ubp_dmg_period = ubp_dmg_period

	new_data.bonus_rhpt = bonus_rhpt
	new_data.ubp_rhpt = ubp_rhpt

	new_data.max_lvl = max_lvl

	new_data.cur_hp = cur_hp

	new_data.upg_lvl_click = upg_lvl_click
	new_data.upg_lvl_hp = upg_lvl_hp
	new_data.upg_lvl_dmg = upg_lvl_dmg
	new_data.upg_lvl_dmg_period = upg_lvl_dmg_period
	new_data.upg_lvl_rhpt = upg_lvl_rhpt

	new_data.cur_price_click = cur_price_click
	new_data.cur_price_hp = cur_price_hp
	new_data.cur_price_dmg = cur_price_dmg
	new_data.cur_price_dmg_period = cur_price_dmg_period
	new_data.cur_price_rhpt = cur_price_rhpt

	return new_data
