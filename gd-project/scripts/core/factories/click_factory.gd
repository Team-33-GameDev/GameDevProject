extends Node
class_name Factory

@export var data: AutoClickerData

var current_hp: int = 0

func _ready():
	if data == null:
		push_error("Factory: data is not set!")
		return
	current_hp = data.max_hp
	
	
	# !!!!IMPORTANT NOTE, Timer is using CPU, in the future timer should be single for 
	# one type of Factory!!!!
	var timer_click = Timer.new()
	timer_click.wait_time = data.click_period
	timer_click.autostart = true
	timer_click.one_shot = false
	timer_click.timeout.connect(_on_click_tick)
	add_child(timer_click)
	
	var timer_damage = Timer.new()
	timer_damage.wait_time = data.damage_period
	timer_damage.autostart = true
	timer_damage.one_shot = false
	timer_damage.timeout.connect(_on_damage_tick)
	add_child(timer_damage)

func _on_click_tick():
	if data == null or current_hp <= 0:
		return
	GameManager.click(data.click_value)
	var efficiency = float(current_hp) / float(data.max_hp)
	#var produced = int(data.output_per_second_full * efficiency)

func _on_damage_tick():
	if data == null or current_hp <= 0:
		return
	current_hp = max(0, current_hp - data.damage)
	if current_hp == 0:
		return


func click_restore():
	if data == null:
		return
	if current_hp >= data.max_hp:
		return
	current_hp = min(data.max_hp, current_hp + data.restore_per_click)

func get_hp_percent() -> float:
	if data == null:
		return 0.0
	return float(current_hp) / float(data.max_hp) * 100.0

func is_active() -> bool:
	return data != null and current_hp > 0
