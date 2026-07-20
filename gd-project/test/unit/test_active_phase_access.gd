extends GutTest


const GameRoomController = preload(
	"res://scripts/core/click_actions/game_room.gd"
)
const ShopStationController = preload(
	"res://scripts/components/shop/click_shop_station.gd"
)


func before_each() -> void:
	QuotaManager.reset_game()


func after_each() -> void:
	QuotaManager.reset_game()


func test_terminal_ui_does_not_pause_active_quota() -> void:
	QuotaManager.current_state = QuotaManager.GameState.RUNNING

	assert_false(QuotaManager.should_pause_terminal_ui())


func test_terminal_ui_still_pauses_during_preparation() -> void:
	QuotaManager.current_state = QuotaManager.GameState.IDLE

	assert_true(QuotaManager.should_pause_terminal_ui())


func test_active_quota_score_can_be_spent_on_upgrades() -> void:
	QuotaManager.current_state = QuotaManager.GameState.RUNNING
	GameManager.score = 100

	assert_eq(GameManager.get_reserved_score(), 0)
	assert_eq(GameManager.get_spendable_score(), 100)
	assert_true(GameManager.spend_score(40))
	assert_eq(GameManager.score, 60)


func test_shop_station_opens_during_active_quota() -> void:
	var station := ShopStationController.new()
	watch_signals(station)
	QuotaManager.current_state = QuotaManager.GameState.RUNNING

	station.click()

	assert_signal_emitted(station, "shop_opened")
	station.free()


func test_post_run_button_cooldown_is_short() -> void:
	assert_gt(GameRoomController.POST_RUN_BUTTON_COOLDOWN, 0.5)
	assert_lt(GameRoomController.POST_RUN_BUTTON_COOLDOWN, 2.0)
