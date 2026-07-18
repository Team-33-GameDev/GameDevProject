extends Node3D
class_name Shop


signal click
signal click_upgraded(upgrade_type: String)


@export var click_upgrade_data: ClickUpgradeData


func _ready() -> void:
	if not click.is_connected(_on_click):
		click.connect(_on_click)

	if click_upgrade_data != null:
		SaveManager.register_click_upgrade_data(
			click_upgrade_data
		)


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
