extends Node3D
class_name Shop
signal click

func _ready() -> void:
	click.connect(_on_click)


# CLICK
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
