extends Node

signal score_changed(new_score: int) 
signal click_power_changed(new_power: int)

# Score state 
var score: int = 0:
	set(value):
		score = value
		score_changed.emit(score)
		#print("game_manager: Score ", score)

# Flat click system
var _base_click_power: int = 1
var _additive_bonuses: Array[int] = []
var _multiplicative_bonuses: Array[float] = []

var total_click_power: int = 1 :
	set(value):
		total_click_power = value
		click_power_changed.emit(value)
		
func has_score(a_score: int) -> bool:
	return score >= a_score
	
func spend_score(cost: int) -> bool:
	if has_score(cost):
		score -= cost
		return true
	return false 
	




func add_additive_bonus(bonus: int) -> void:
	_additive_bonuses.append(bonus)
	_recalculate_click_power()

func add_multiplicative_bonus(factor: float) -> void:
	_multiplicative_bonuses.append(factor)
	_recalculate_click_power()




# Method for removing time-limited additive upgrades
func remove_additive_bonus(bonus: int) -> bool:
	var idx = _additive_bonuses.find(bonus)
	if idx != -1:
		_additive_bonuses.remove_at(idx)
		_recalculate_click_power()
		return true
	return false

# Method for removing time-limited multiplicative upgrades
func remove_multiplicative_bonus(factor: float) -> bool:
	var idx = _multiplicative_bonuses.find(factor)
	if idx != -1:
		_multiplicative_bonuses.remove_at(idx)
		_recalculate_click_power()
		return true
	return false






# Method that recalculate total_click_power after upgrade based on applied upgrades 
func _recalculate_click_power() -> void:
	var power = _base_click_power
	for bonus in _additive_bonuses:
		power += bonus
	for factor in _multiplicative_bonuses:
		power = int(power * factor)
	total_click_power = power
	print ("game_manager: Total click power have been recalculated")



func add_score(amount: int) -> void:
	score += amount

func click(amount: int = 0) -> void:
	add_score(amount)






#
#func _on_factory_clicks(amount: int):
	#click()

#func _on_factory_charge_updated(current: int, max: int):
	#pass
#
#func _on_factory_depleted():
	#pass




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add_additive_bonus(5)
	#add_multiplicative_bonus(2.0)
	#print("Total click power: ", total_click_power)
	pass



func _process(delta: float) -> void:
	pass
	
	#pass # Replace with function body.wwda s


	#
	#if click is GrowingClickBuff:
		#click = click._wrappee

# Called every frame. 'delta' is the elapsed time since the previous frame.
