extends GutTest


const BigButtonController = preload(
	"res://scripts/core/quota_decreasers/quota_decrease.gd"
)


func before_each() -> void:
	QuotaManager.reset_game()


func after_all() -> void:
	QuotaManager.reset_game()


func test_factory_wear_is_doubled() -> void:
	var data := AutoClickerData.new()
	data.max_hp = 100
	data.dmg = 5
	data.dmg_tick_period = 1
	data.init()
	data.cur_tick_dmg = 1

	assert_true(data.apply_dmg())
	assert_eq(data.cur_hp, 90)


func test_big_button_uses_old_five_percent_step() -> void:
	assert_eq(BigButtonController.REQUIRED_JUMPS, 3)
	assert_almost_eq(
		BigButtonController.DECREASE_PERCENT,
		0.05,
		0.0001
	)


func test_big_button_keeps_thirty_percent_floor() -> void:
	QuotaManager._start_run()
	var base_target: int = QuotaManager.current_quota_target

	for _attempt in range(20):
		QuotaManager.decrease_quota(0.05)

	assert_eq(
		QuotaManager.current_quota_target,
		ceili(float(base_target) * 0.70)
	)
