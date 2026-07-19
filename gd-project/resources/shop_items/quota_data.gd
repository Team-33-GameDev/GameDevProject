extends ShopItemData
class_name QuotaData

@export_category("Start Values")
@export var q_target: int = 30 # Score target for this quota
@export var q_time_left: float = 10.0 # Current remaining time (runtime)
@export var cooldown: float = 0.0 # Cooldown of the reduction ability
@export var cooldown_rem: float = 0.0 # Remaining cooldown time (runtime)
@export var condition_click: int = 5 # Clicks required to trigger ability
@export var click_value: int = 1
@export var cur_condition_click: int = 0 # Current click progress (runtime)
@export var q_decrease_percent: float = 0.05 # Percent of quota reduction per use
# Percent of quota reduction per use



func init() -> void:
	cooldown_rem = 0.0
	cur_condition_click = 0



func add_click() -> bool:
	if cur_condition_click < condition_click:
		cur_condition_click += click_value
		return true
	return false

func is_ability_ready() -> bool:
	return cur_condition_click >= condition_click and cooldown_rem <= 0.0

func use_ability() -> bool:
	if not is_ability_ready():
		return false
	cur_condition_click = 0
	cooldown_rem = cooldown
	return true

func update_cooldown(delta: float) -> void:
	if cooldown_rem > 0:
		cooldown_rem = max(0.0, cooldown_rem - delta)

func apply_decrease() -> void:
	QuotaManager.decrease_quota(q_decrease_percent)



func get_decrease_percent_value() -> float:
	return q_decrease_percent * 100.0

func duplicate_data() -> QuotaData:
	var new_data = QuotaData.new()
	new_data.q_target = q_target
	new_data.q_time_left = q_time_left
	new_data.cooldown = cooldown
	new_data.cooldown_rem = cooldown_rem
	new_data.condition_click = condition_click
	new_data.click_value = click_value
	new_data.cur_condition_click = cur_condition_click
	new_data.q_decrease_percent = q_decrease_percent
	return new_data
	
	
	
