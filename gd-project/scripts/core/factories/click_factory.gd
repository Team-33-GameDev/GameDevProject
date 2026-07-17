extends Node3D
class_name Factory
signal request_buy_factory(index: int)
signal request_upgrade_click(index: int)
signal request_upgrade_hp(index: int)
signal request_upgrade_damage(index: int)
signal request_upgrade_damage_period(index: int)
signal request_upgrade_rhpt(index: int)

@export var template_data: AutoClickerData

@export var label_color: Color
@export var label_text: String
@onready var name_label = $NameLable
var manager: FactoryManager
var index = 0
var data: AutoClickerData

var timer: Timer
signal click_performed()
signal data_updated()

func _ready() -> void:
	name_label.outline_modulate = label_color
	name_label.text = label_text
	if template_data == null:
		push_error("Factory: template_data is null!")
		return
	data = template_data.duplicate_data()
	data.init()
	data.is_purchased = false 
	
	var parent = get_parent()
	if parent is FactoryManager:
		manager = parent
		data.normalize_dps(manager.tick_interval)
	else:
		push_error("Factory: parent is not FactoryManager!")
		return
	

	return


@onready var info_label = $NameLable

func _update_ui():
	if not info_label or not data:
		return
	var status = "PURCHASED" if data.is_purchased else "LOCKED"
	var text = "%s [%s]
	\nHP: %d/%d (lvl %d) LVL UP: price %d 
	\nClick: %d (lvl %d) LVL UP: price %d
	\nDmg: %d (lvl %d) LVL UP: price %d
	\nDmg Period: %d ticks (lvl %d) LVL UP: %d
	\nRestore: %d HP/tick (lvl %d) LVL UP: %d
	\nClick ticks: %d/%d 	
	\nDmg ticks: %d/%d" % [
			template_data.item_name,
			status,
			
			data.cur_hp,
			data.max_hp,
			data.upg_lvl_hp,
			data.cur_price_hp,

			data.click_value,
			data.upg_lvl_click,
			data.cur_price_click,
			
			data.dmg,
			data.upg_lvl_dmg,
			data.cur_price_dmg,
			
			data.dmg_tick_period,
			data.upg_lvl_dmg_period,
			data.cur_price_dmg_period,
			
			data.rhpt,
			data.upg_lvl_rhpt,
			data.cur_price_rhpt,
			
			data.cur_click_ticks,
			data.click_ticks_period,
			
			data.cur_tick_dmg,
			data.dmg_tick_period
		]
	info_label.text = text
#func create_local_data() -> void:
	#data = template_data.duplicate_data()
	#data.init()
	#data.is_purchased = false


func is_active() -> bool:
	return data != null and data.is_purchased and data.is_alive()

func process_tick() -> void:
	if not data or not data.is_purchased:
		return
	data.cur_click_ticks += 1
	data.cur_tick_dmg += 1
	_update_ui()
	if data.click():
		click_performed.emit()
		data_updated.emit()
		#_update_ui()

	if data.apply_dmg():
		data_updated.emit()
		#_update_ui()
		





func restore_hp() -> void:
	if not data or not data.is_purchased:
		return
	if data.restore_hp():
		data_updated.emit()
		_update_ui()
		



# Upgrades 
func upgrade_click() -> bool:
	if not data or not data.is_purchased:
		return false
	if data.upg_click_value():
		#data_updated.emit()
		_update_ui()
		return true
	return false

func upgrade_hp() -> bool:
	if not data or not data.is_purchased:
		return false
	if data.upg_max_hp():
		#data_updated.emit()
		_update_ui()
		return true
	return false

func upgrade_damage() -> bool:
	if (
		not data
		or not data.is_purchased
		or manager == null
	):
		return false

	if data.upg_dmg(manager.tick_interval):
		_update_ui()
		return true

	return false

func upgrade_damage_period() -> bool:
	if not data or not data.is_purchased:
		return false
	if data.upg_dmg_period():
		_update_ui()
		#data_updated.emit()
		return true
	return false

func upgrade_rhpt() -> bool:
	if not data or not data.is_purchased:
		return false
	if data.upg_rhpt():
		_update_ui()
		#data_updated.emit()
		return true
	return false


func get_data_copy() -> AutoClickerData:
	return data.duplicate_data() if data else null

func restore_from_data(
	saved_data: AutoClickerData
) -> void:
	if saved_data == null:
		return

	data = saved_data.duplicate_data()

	if manager != null:
		data.normalize_dps(
			manager.tick_interval
		)
	else:
		data.dmg = maxi(1, data.dmg)
		data.dmg_tick_period = maxi(
			1,
			data.dmg_tick_period
		)

	data.cur_hp = mini(
		data.cur_hp,
		data.max_hp
	)

	
func _on_click_button_button_clicked() -> void:
	request_buy_factory.emit(index)

func _on_click_button_2_button_clicked() -> void:
	request_upgrade_click.emit(index)

func _on_click_button_3_button_clicked() -> void:
	request_upgrade_hp.emit(index)

func _on_click_button_4_button_clicked() -> void:
	request_upgrade_damage.emit(index)

func _on_click_button_5_button_clicked() -> void:
	request_upgrade_damage_period.emit(index)

func _on_click_button_6_button_clicked() -> void:
	request_upgrade_rhpt.emit(index)

func _on_click_button_7_button_clicked() -> void:
	restore_hp()
