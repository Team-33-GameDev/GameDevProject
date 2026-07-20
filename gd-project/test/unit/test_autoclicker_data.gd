extends GutTest


var data: AutoClickerData


func before_each() -> void:
	QuotaManager.current_state = QuotaManager.GameState.GAME_OVER
	QuotaManager.current_quota_target = 0
	GameManager.score = 100

	data = AutoClickerData.new()
	data.dmg = 5
	data.dmg_tick_period = 100
	data.bonus_dmg = -1
	data.bonus_dmg_period = 10
	data.ubp_dmg = 10
	data.ubp_dmg_period = 10
	data.init()
	data.normalize_dps(0.01)


func after_all() -> void:
	QuotaManager.reset_game()


func test_dps_is_derived_from_real_damage_timing() -> void:
	assert_almost_eq(data.get_dps(0.01), 5.0, 0.001)


func test_damage_upgrade_reduces_real_self_damage() -> void:
	assert_true(data.upg_dmg(0.01) > 0.0)
	assert_eq(data.dmg, 4)
	assert_almost_eq(data.get_dps(0.01), 4.0, 0.001)
	assert_eq(GameManager.score, 90)


func test_damage_period_upgrade_reduces_damage_frequency() -> void:
	assert_true(data.upg_dmg_period() > 0.0)
	assert_eq(data.dmg_tick_period, 110)
	assert_almost_eq(data.get_dps(0.01), 4.545, 0.001)
	assert_eq(GameManager.score, 90)
