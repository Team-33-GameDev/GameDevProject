extends GutTest


const FACTORY_TICK_INTERVAL := 0.01


func test_click_upgrade_curve_matches_balance_model() -> void:
	var data := load(
		"res://resources/shop_items/basic_click.tres"
	) as ClickUpgradeData

	assert_not_null(data)
	assert_eq(data.add_bonus_per_level, 2)
	assert_eq(data.add_price_base, 120)
	assert_eq(data.add_price_mult, 2.0)
	assert_eq(data.mult_price_base, 1500)
	assert_eq(data.mult_price_mult, 3.0)


func test_big_button_is_an_accessibility_buffer_not_main_income() -> void:
	var controller := preload(
		"res://scripts/core/quota_decreasers/quota_decrease.gd"
	)

	assert_eq(controller.REQUIRED_JUMPS, 3)
	assert_almost_eq(controller.DECREASE_PERCENT, 0.05, 0.0001)
	assert_almost_eq(QuotaManager.MINIMUM_QUOTA_RATIO, 0.70, 0.0001)


func test_factory_curve_matches_balance_model() -> void:
	_assert_factory(
		"wooden", 0, 5.0, 45.0, 5.0, 100
	)
	_assert_factory(
		"stone", 225, 15.0, 60.0, 5.0, 150
	)
	_assert_factory(
		"copper", 900, 50.0, 75.2, 15.0, 500
	)
	_assert_factory(
		"iron", 3000, 150.0, 90.0, 50.0, 1500
	)
	_assert_factory(
		"golden", 11000, 450.0, 105.0, 150.0, 5500
	)
	_assert_factory(
		"diamond", 55000, 1350.0, 120.0, 450.0, 30000
	)


func _assert_factory(
	resource_name: String,
	expected_price: int,
	expected_cps: float,
	expected_lifetime: float,
	expected_bonus_cps: float,
	expected_upgrade_price: int
) -> void:
	var path := (
		"res://resources/shop_items/autoclicker/"
		+ resource_name
		+ "_autoclick_data.tres"
	)
	var data := load(path) as AutoClickerData

	assert_not_null(data, path)
	if data == null:
		return

	var cps := (
		float(data.click_value)
		/ (FACTORY_TICK_INTERVAL * data.click_ticks_period)
	)
	var damage_events := ceili(
		float(data.max_hp) / float(data.dmg)
	)
	var lifetime := (
		float(damage_events)
		* FACTORY_TICK_INTERVAL
		* float(data.dmg_tick_period)
	)
	var bonus_cps := (
		float(data.bonus_click_value)
		/ (FACTORY_TICK_INTERVAL * data.click_ticks_period)
	)
	var restore_presses := ceili(
		float(data.max_hp) / float(data.rhpt)
	)

	assert_eq(data.item_price, expected_price, path)
	assert_almost_eq(cps, expected_cps, 0.01, path)
	assert_almost_eq(lifetime, expected_lifetime, 0.01, path)
	assert_almost_eq(bonus_cps, expected_bonus_cps, 0.01, path)
	assert_eq(data.ubp_click_value, expected_upgrade_price, path)
	assert_eq(restore_presses, 4, path)
