extends GutTest
# ClickUpgradeData tests. It's a pure Resource — ideal for unit testing.
# Every test creates its OWN instance, so no autoloads are needed
# and the tests are fully isolated.

var data: ClickUpgradeData

func before_each():
	data = ClickUpgradeData.new()
	# Defaults from the script:
	# base_click_power=1, add_bonus=1, mult_bonus=2.0,
	# percent_bonus=0.05, crit_chance=0.05, crit_mult=2.0

# ============ PRICES ============

func test_initial_add_price():
	assert_eq(data.get_add_price(), 10, "add price at level 0 = base (10)")

func test_add_price_grows_geometrically():
	data.upgrade_add()
	assert_eq(data.get_add_price(), 15, "10 * 1.5^1 = 15")
	data.upgrade_add()
	assert_eq(data.get_add_price(), 22, "int(10 * 1.5^2) = int(22.5) = 22")

func test_mult_price_grows():
	assert_eq(data.get_mult_price(), 20, "mult base price = 20")
	data.upgrade_mult()
	assert_eq(data.get_mult_price(), 40, "20 * 2^1 = 40")

func test_crit_price_grows():
	assert_eq(data.get_crit_price(), 50)
	data.upgrade_crit()
	assert_eq(data.get_crit_price(), 150, "50 * 3^1 = 150")

# ============ CLICK CALCULATION (deterministic cases) ============

func test_base_click_is_one():
	assert_eq(data.calculate_click(), 1, "click without upgrades = 1")

func test_add_upgrade_increases_click():
	data.upgrade_add()  # +1 per level
	data.upgrade_add()
	assert_eq(data.calculate_click(), 3, "1 + 2*1 = 3")

func test_mult_upgrade_doubles():
	data.upgrade_mult()  # x2 per level
	assert_eq(data.calculate_click(), 2, "1 * 2^1 = 2")

func test_add_applies_before_mult():
	# Lock in the order: add BEFORE mult
	data.upgrade_add()   # +1
	data.upgrade_mult()  # x2
	assert_eq(data.calculate_click(), 4, "(1+1)*2 = 4")

func test_percent_bonus_grows_with_total_clicks():
	data.upgrade_percent()  # 5% of total_clicks per level
	# First click: total_clicks=0, bonus 0 -> power 1
	assert_eq(data.calculate_click(), 1, "first click has no accumulated bonus")
	# Inflate the click counter
	data.total_clicks = 100
	# bonus = 100 * (1 * 0.05) = 5 -> power = 1 + 5 = 6
	assert_eq(data.calculate_click(), 6, "percent bonus grows with total_clicks")

func test_total_clicks_increments():
	data.calculate_click()
	data.calculate_click()
	data.calculate_click()
	assert_eq(data.total_clicks, 3, "each calculate_click increments the counter")

# ============ CRITS (via guaranteed probabilities) ============

func test_crit_never_fires_at_level_zero():
	# crit_chance = 0 * 0.05 = 0 -> randf() < 0 is impossible
	for i in 50:
		assert_eq(data.calculate_click_preview(), 1,
			"with crit_level=0 a crit must never fire")

func test_crit_always_fires_at_guaranteed_chance():
	# 20 levels * 0.05 = 1.0 -> 100% chance
	data.crit_level = 20
	for i in 50:
		assert_eq(data.calculate_click_preview(), 2,
			"with chance 1.0 a crit always fires: 1 * 2.0 = 2")

# ============ PREVIEW MUST NOT MUTATE STATE ============

func test_preview_does_not_increment_clicks():
	data.calculate_click_preview()
	data.calculate_click_preview()
	assert_eq(data.total_clicks, 0,
		"preview must not touch total_clicks — it only shows a number")

# ============ COPYING ============

func test_duplicate_data_copies_levels():
	data.upgrade_add()
	data.upgrade_mult()
	data.total_clicks = 42
	var copy = data.duplicate_data()
	assert_eq(copy.add_level, 1)
	assert_eq(copy.mult_level, 1)
	assert_eq(copy.total_clicks, 42)

func test_duplicate_is_independent():
	var copy = data.duplicate_data()
	copy.upgrade_add()
	assert_eq(data.add_level, 0,
		"modifying the copy must not affect the original")
