#extends Control
#
#var selected_factory: Factory = null
#
#@onready var name_label = $Panel/NameLabel
#@onready var hp_label = $Panel/HPLabel
#@onready var click_label = $Panel/ClickLabel
#@onready var damage_label = $Panel/DamageLabel
#@onready var damage_period_label = $Panel/DamagePeriodLabel
#@onready var rhpt_label = $Panel/RhptLabel
#
#func _ready():
	##factory_updated.connect(_on_factory_updated)
#
	##visible = false
#
#
#func select_factory(factory: Factory):
	#if selected_factory:
		#selected_factory.data_updated.disconnect(_update_display)
	#
	#selected_factory = factory
	#if factory:
		#factory.data_updated.connect(_update_display)
		#_update_display()
		#visible = true
	#else:
		#visible = false
#
#func _update_display():
	#if not selected_factory or not selected_factory.data:
		#visible = false
		#return
	#
	#var data = selected_factory.data
	#name_label.text = data.item_name
	#hp_label.text = "HP: %d / %d" % [data.cur_hp, data.max_hp]
	#click_label.text = "Click: %d (lvl %d)" % [data.click_value, data.upg_lvl_click]
	#damage_label.text = "Damage: %d (lvl %d)" % [data.dmg, data.upg_lvl_dmg]
	#damage_period_label.text = "Dmg period: %d ticks (lvl %d)" % [data.dmg_tick_period, data.upg_lvl_dmg_period]
	#rhpt_label.text = "Restore: %d HP/tick (lvl %d)" % [data.rhpt, data.upg_lvl_rhpt]
