extends Node3D
class_name Shop


signal click
signal click_upgraded(upgrade_type: String)
signal crowbar_purchased
signal sledgehammer_purchased


@export var click_upgrade_data: ClickUpgradeData

@export_category("Crowbar")
@export_range(0, 1000000, 1)
var crowbar_price: int = 25


var _crowbar: Node3D = null
var _crowbar_purchased: bool = false
var _sledgehammer: RigidBody3D = null
var _sledgehammer_purchased: bool = false


func _ready() -> void:
	if not click.is_connected(_on_click):
		click.connect(_on_click)

	if click_upgrade_data != null:
		SaveManager.register_click_upgrade_data(
			click_upgrade_data
		)

	call_deferred("_setup_crowbar")
	call_deferred("_setup_sledgehammer")


# ------------------------------------------------------------------
# Crowbar
# ------------------------------------------------------------------

func _setup_crowbar() -> void:
	_crowbar = _find_crowbar()

	if _crowbar == null:
		push_warning(
			"ShopSystem: Crowbar was not found."
		)
		return

	if _crowbar.has_method(&"set_available"):
		_crowbar.call(
			&"set_available",
			_crowbar_purchased
		)


func _find_crowbar() -> Node3D:
	var crowbar_node: Node = (
		get_tree().get_first_node_in_group(&"crowbar")
	)

	if crowbar_node is Node3D:
		return crowbar_node as Node3D

	return null


func buy_crowbar() -> bool:
	if _crowbar_purchased:
		return false

	if _crowbar == null or not is_instance_valid(_crowbar):
		_crowbar = _find_crowbar()

	if _crowbar == null:
		push_error(
			"ShopSystem: Crowbar purchase failed: "
			+ "scene instance was not found."
		)
		return false

	if not GameManager.spend_score(crowbar_price):
		return false

	_crowbar_purchased = true

	if _crowbar.has_method(&"set_available"):
		_crowbar.call(&"set_available", true)
	else:
		_crowbar.visible = true

	crowbar_purchased.emit()
	SaveManager.save_game()

	return true


func get_crowbar_price() -> int:
	return crowbar_price


func is_crowbar_purchased() -> bool:
	return _crowbar_purchased


func restore_crowbar_purchase(value: bool) -> void:
	_crowbar_purchased = value

	if _crowbar == null or not is_instance_valid(_crowbar):
		_crowbar = _find_crowbar()

	if _crowbar == null:
		call_deferred("_setup_crowbar")
		return

	if _crowbar.has_method(&"set_available"):
		_crowbar.call(&"set_available", value)
	else:
		_crowbar.visible = value


# Compatibility with the accessibility checkpoint introduced after the
# original crowbar shop integration.
func restore_crowbar_purchased(value: bool) -> void:
	restore_crowbar_purchase(value)


# ------------------------------------------------------------------
# Sledgehammer
#
# Its original physics and interaction script stay untouched. The shop only
# controls visibility and whether the player may pick it up. Collision remains
# active while hidden, so the body settles naturally on the floor.
# ------------------------------------------------------------------

func _setup_sledgehammer() -> void:
	_sledgehammer = _find_sledgehammer()

	if _sledgehammer == null:
		push_warning("ShopSystem: Sledgehammer was not found.")
		return

	_set_sledgehammer_available(_sledgehammer_purchased)


func _find_sledgehammer() -> RigidBody3D:
	var node := get_tree().get_first_node_in_group(
		&"sledgehammer"
	)

	if node is RigidBody3D:
		return node as RigidBody3D

	return null


func buy_sledgehammer() -> bool:
	if _sledgehammer_purchased:
		return false

	if _sledgehammer == null or not is_instance_valid(_sledgehammer):
		_sledgehammer = _find_sledgehammer()

	if _sledgehammer == null:
		push_error(
			"ShopSystem: Sledgehammer purchase failed: "
			+ "scene instance was not found."
		)
		return false

	if not GameManager.spend_score(get_sledgehammer_price()):
		return false

	_sledgehammer_purchased = true
	_set_sledgehammer_available(true)
	sledgehammer_purchased.emit()
	SaveManager.save_game()
	return true


func get_sledgehammer_price() -> int:
	if _sledgehammer != null and is_instance_valid(_sledgehammer):
		var item_data: Variant = _sledgehammer.get(&"data")
		if item_data is ShopItemData:
			return maxi(0, (item_data as ShopItemData).item_price)

	return 1000


func is_sledgehammer_purchased() -> bool:
	return _sledgehammer_purchased


func restore_sledgehammer_purchase(value: bool) -> void:
	_sledgehammer_purchased = value

	if _sledgehammer == null or not is_instance_valid(_sledgehammer):
		_sledgehammer = _find_sledgehammer()

	if _sledgehammer == null:
		call_deferred("_setup_sledgehammer")
		return

	_set_sledgehammer_available(value)


func _set_sledgehammer_available(value: bool) -> void:
	if _sledgehammer == null or not is_instance_valid(_sledgehammer):
		return

	_sledgehammer.visible = value

	if value:
		if not _sledgehammer.is_in_group(&"pickable"):
			_sledgehammer.add_to_group(&"pickable")
	else:
		_sledgehammer.remove_from_group(&"pickable")


# ------------------------------------------------------------------
# Click processing
# ------------------------------------------------------------------

func _on_click() -> void:
	var power: int = 1

	if click_upgrade_data != null:
		power = click_upgrade_data.calculate_click()

	GameManager.click(power)


# ------------------------------------------------------------------
# Additive upgrade
# ------------------------------------------------------------------

func upgrade_click_add() -> bool:
	if click_upgrade_data == null:
		return false

	var price: int = get_click_add_price()

	if not GameManager.has_score(price):
		return false

	click_upgrade_data.upgrade_add()
	GameManager.spend_score(price)

	click_upgraded.emit("add")

	SaveManager.save_game()

	return true


func get_click_add_level() -> int:
	if click_upgrade_data == null:
		return -1

	return click_upgrade_data.add_level


func get_click_add_price() -> int:
	if click_upgrade_data == null:
		return -1

	return click_upgrade_data.get_add_price()


# ------------------------------------------------------------------
# Multiplicative upgrade
# ------------------------------------------------------------------

func upgrade_click_mult() -> bool:
	if click_upgrade_data == null:
		return false

	var price: int = get_click_mult_price()

	if not GameManager.has_score(price):
		return false

	click_upgrade_data.upgrade_mult()
	GameManager.spend_score(price)

	click_upgraded.emit("mult")

	SaveManager.save_game()

	return true


func get_click_mult_level() -> int:
	if click_upgrade_data == null:
		return -1

	return click_upgrade_data.mult_level


func get_click_mult_price() -> int:
	if click_upgrade_data == null:
		return -1

	return click_upgrade_data.get_mult_price()


# ------------------------------------------------------------------
# Percent upgrade
# Kept for the existing backend and future shop expansion.
# ------------------------------------------------------------------

func upgrade_click_percent() -> bool:
	if click_upgrade_data == null:
		return false

	var price: int = get_click_percent_price()

	if not GameManager.has_score(price):
		return false

	click_upgrade_data.upgrade_percent()
	GameManager.spend_score(price)

	click_upgraded.emit("percent")

	SaveManager.save_game()

	return true


func get_click_percent_level() -> int:
	if click_upgrade_data == null:
		return -1

	return click_upgrade_data.percent_level


func get_click_percent_price() -> int:
	if click_upgrade_data == null:
		return -1

	return click_upgrade_data.get_percent_price()


# ------------------------------------------------------------------
# Critical upgrade
# Kept for the existing backend and future shop expansion.
# ------------------------------------------------------------------

func upgrade_click_crit() -> bool:
	if click_upgrade_data == null:
		return false

	var price: int = get_click_crit_price()

	if not GameManager.has_score(price):
		return false

	click_upgrade_data.upgrade_crit()
	GameManager.spend_score(price)

	click_upgraded.emit("crit")

	SaveManager.save_game()

	return true


func get_click_crit_level() -> int:
	if click_upgrade_data == null:
		return -1

	return click_upgrade_data.crit_level


func get_click_crit_price() -> int:
	if click_upgrade_data == null:
		return -1

	return click_upgrade_data.get_crit_price()


# ------------------------------------------------------------------
# Deterministic click-power preview
#
# ClickUpgradeData.calculate_click_preview() currently performs a
# random critical roll. That makes it unsuitable for shop UI.
#
# The methods below calculate normal click power without a random
# critical hit, so the displayed values remain stable.
# ------------------------------------------------------------------

func get_current_click_power() -> int:
	if click_upgrade_data == null:
		return 0

	return _calculate_click_power_for_levels(
		click_upgrade_data.add_level,
		click_upgrade_data.mult_level
	)


func get_click_power_after_add_upgrade() -> int:
	if click_upgrade_data == null:
		return 0

	return _calculate_click_power_for_levels(
		click_upgrade_data.add_level + 1,
		click_upgrade_data.mult_level
	)


func get_click_power_after_mult_upgrade() -> int:
	if click_upgrade_data == null:
		return 0

	return _calculate_click_power_for_levels(
		click_upgrade_data.add_level,
		click_upgrade_data.mult_level + 1
	)


func _calculate_click_power_for_levels(
	add_level_value: int,
	mult_level_value: int
) -> int:
	if click_upgrade_data == null:
		return 0

	var power: int = click_upgrade_data.base_click_power

	power += (
		add_level_value
		* click_upgrade_data.add_bonus_per_level
	)

	var percent_bonus: float = (
		click_upgrade_data.total_clicks
		* (
			click_upgrade_data.percent_level
			* click_upgrade_data.percent_bonus_per_level
		)
	)

	power += int(percent_bonus)

	power = int(
		power
		* pow(
			click_upgrade_data.mult_bonus_per_level,
			mult_level_value
		)
	)

	return maxi(power, 0)
