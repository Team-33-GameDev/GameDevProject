extends Control
class_name ClickShopScreen


signal close_requested
signal crowbar_requested
signal hammer_requested


@export var allow_close: bool = false


@onready var balance_label: Label = $BalanceLabel
@onready var status_label: Label = $StatusLabel

@onready var additive_card: ClickShopCard = (
	$Cards/AdditiveCard
)

@onready var multiplicative_card: ClickShopCard = (
	$Cards/MultiplicativeCard
)

@onready var crowbar_card: ClickShopCard = (
	$Cards/CrowbarCard
)

@onready var hammer_card: ClickShopCard = (
	$Cards/HammerCard
)


var shop_backend: Shop = null
var _default_status: String = ""


func _ready() -> void:
	_default_status = (
		"ESC - CLOSE"
		if allow_close
		else "SHOP TERMINAL"
	)

	status_label.text = _default_status

	if not additive_card.pressed.is_connected(
		_on_additive_pressed
	):
		additive_card.pressed.connect(
			_on_additive_pressed
		)

	if not multiplicative_card.pressed.is_connected(
		_on_multiplicative_pressed
	):
		multiplicative_card.pressed.connect(
			_on_multiplicative_pressed
		)

	if not crowbar_card.pressed.is_connected(
		_on_crowbar_pressed
	):
		crowbar_card.pressed.connect(
			_on_crowbar_pressed
		)

	if not hammer_card.pressed.is_connected(
		_on_hammer_pressed
	):
		hammer_card.pressed.connect(
			_on_hammer_pressed
		)

	if not GameManager.score_changed.is_connected(
		_on_score_changed
	):
		GameManager.score_changed.connect(
			_on_score_changed
		)

	_refresh()


func setup(new_shop_backend: Shop) -> void:
	if shop_backend == new_shop_backend:
		_refresh()
		return

	_disconnect_shop_backend()

	shop_backend = new_shop_backend

	if (
		shop_backend != null
		and not shop_backend.click_upgraded.is_connected(
			_on_click_upgraded
		)
	):
		shop_backend.click_upgraded.connect(
			_on_click_upgraded
		)

	_refresh()


func _exit_tree() -> void:
	_disconnect_shop_backend()

	if GameManager.score_changed.is_connected(
		_on_score_changed
	):
		GameManager.score_changed.disconnect(
			_on_score_changed
		)


func _disconnect_shop_backend() -> void:
	if shop_backend == null:
		return

	if not is_instance_valid(shop_backend):
		return

	if shop_backend.click_upgraded.is_connected(
		_on_click_upgraded
	):
		shop_backend.click_upgraded.disconnect(
			_on_click_upgraded
		)


# ------------------------------------------------------------------
# Screen refresh
# ------------------------------------------------------------------

func _refresh() -> void:
	balance_label.text = "SCORE: %d" % GameManager.score

	_refresh_placeholders()

	if not _shop_is_ready():
		_show_missing_backend()
		return

	var data: ClickUpgradeData = (
		shop_backend.click_upgrade_data
	)

	var current_power: int = (
		shop_backend.get_current_click_power()
	)

	var add_next_power: int = (
		shop_backend
		.get_click_power_after_add_upgrade()
	)

	var mult_next_power: int = (
		shop_backend
		.get_click_power_after_mult_upgrade()
	)

	var add_price: int = (
		shop_backend.get_click_add_price()
	)

	var mult_price: int = (
		shop_backend.get_click_mult_price()
	)

	additive_card.set_content(
		"ADDITIVE UPGRADE",
		"LVL %d | +%d | %d > %d" % [
			shop_backend.get_click_add_level(),
			data.add_bonus_per_level,
			current_power,
			add_next_power
		],
		"COST",
		str(add_price),
		GameManager.has_score(add_price),
		true
	)

	multiplicative_card.set_content(
		"MULTIPLICATIVE UPGRADE",
		"LVL %d | x%s | %d > %d" % [
			shop_backend.get_click_mult_level(),
			_format_multiplier(
				data.mult_bonus_per_level
			),
			current_power,
			mult_next_power
		],
		"COST",
		str(mult_price),
		GameManager.has_score(mult_price),
		true
	)


func _refresh_placeholders() -> void:
	crowbar_card.set_content(
		"CROWBAR",
		"OPENS FACTORY ROOM",
		"STATUS",
		"COMING SOON",
		true,
		false
	)

	hammer_card.set_content(
		"HAMMER",
		"OPENS BIG BUTTON ROOM",
		"STATUS",
		"COMING SOON",
		true,
		false
	)


func _show_missing_backend() -> void:
	additive_card.set_content(
		"ADDITIVE UPGRADE",
		"BACKEND NOT FOUND",
		"COST",
		"--",
		false,
		false
	)

	multiplicative_card.set_content(
		"MULTIPLICATIVE UPGRADE",
		"BACKEND NOT FOUND",
		"COST",
		"--",
		false,
		false
	)


func _shop_is_ready() -> bool:
	return (
		shop_backend != null
		and is_instance_valid(shop_backend)
		and shop_backend.click_upgrade_data != null
	)


# ------------------------------------------------------------------
# Purchases
# ------------------------------------------------------------------

func _on_additive_pressed() -> void:
	if not _shop_is_ready():
		_set_status("SHOP BACKEND NOT FOUND")
		return

	var price: int = (
		shop_backend.get_click_add_price()
	)

	var bonus: int = (
		shop_backend
		.click_upgrade_data
		.add_bonus_per_level
	)

	if shop_backend.upgrade_click_add():
		var new_power: int = (
			shop_backend.get_current_click_power()
		)

		_set_status(
			"PURCHASED: +%d | CLICK POWER: %d"
			% [
				bonus,
				new_power
			]
		)
	else:
		_set_status(
			"NOT ENOUGH SCORE - NEED %d"
			% price
		)

	_refresh()


func _on_multiplicative_pressed() -> void:
	if not _shop_is_ready():
		_set_status("SHOP BACKEND NOT FOUND")
		return

	var price: int = (
		shop_backend.get_click_mult_price()
	)

	var multiplier: String = _format_multiplier(
		shop_backend
		.click_upgrade_data
		.mult_bonus_per_level
	)

	if shop_backend.upgrade_click_mult():
		var new_power: int = (
			shop_backend.get_current_click_power()
		)

		_set_status(
			"PURCHASED: x%s | CLICK POWER: %d"
			% [
				multiplier,
				new_power
			]
		)
	else:
		_set_status(
			"NOT ENOUGH SCORE - NEED %d"
			% price
		)

	_refresh()


# ------------------------------------------------------------------
# Future item placeholders
# ------------------------------------------------------------------

func _on_crowbar_pressed() -> void:
	crowbar_requested.emit()

	_set_status(
		"CROWBAR IS NOT AVAILABLE YET"
	)


func _on_hammer_pressed() -> void:
	hammer_requested.emit()

	_set_status(
		"HAMMER IS NOT AVAILABLE YET"
	)


# ------------------------------------------------------------------
# Signals and helpers
# ------------------------------------------------------------------

func _on_score_changed(
	_new_score: int
) -> void:
	_refresh()


func _on_click_upgraded(
	_upgrade_type: String
) -> void:
	_refresh()


func _set_status(message: String) -> void:
	status_label.text = message


func _format_multiplier(value: float) -> String:
	var rounded_value: float = round(value)

	if is_equal_approx(
		value,
		rounded_value
	):
		return str(int(rounded_value))

	return "%.2f" % value


func _input(event: InputEvent) -> void:
	if not allow_close:
		return

	if not is_visible_in_tree():
		return

	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close_requested.emit()
