extends GutTest
# GameManager tests: score, spending, click power system, tickets.
# GameManager is an autoload, so it is directly accessible in tests.

func before_each():
	# Full state reset before EACH test so tests don't affect each other
	GameManager.score = 0
	GameManager.tickets = 0
	GameManager._additive_bonuses.clear()
	GameManager._multiplicative_bonuses.clear()
	GameManager._recalculate_click_power()
	# IMPORTANT: QuotaManager listens to score_changed and starts a run
	# on the first score change from IDLE. Set GAME_OVER so score tests
	# don't accidentally start the game timer.
	QuotaManager.current_state = QuotaManager.GameState.GAME_OVER

func after_all():
	# Restore managers to a clean state after the whole suite
	QuotaManager.reset_game()

# ============ SCORE ============

func test_add_score():
	GameManager.add_score(50)
	assert_eq(GameManager.score, 50, "add_score should increase the score")

func test_add_score_accumulates():
	GameManager.add_score(10)
	GameManager.add_score(15)
	assert_eq(GameManager.score, 25, "score should accumulate")

func test_has_score_exact():
	GameManager.add_score(100)
	assert_true(GameManager.has_score(100), "exactly 100 with 100 should be enough")

func test_has_score_insufficient():
	GameManager.add_score(99)
	assert_false(GameManager.has_score(100), "99 < 100 is not enough")

func test_spend_score_success():
	GameManager.add_score(100)
	var ok = GameManager.spend_score(30)
	assert_true(ok, "spending with enough score should succeed")
	assert_eq(GameManager.score, 70, "remainder after spending")

func test_spend_score_insufficient_does_not_change_score():
	GameManager.add_score(10)
	var ok = GameManager.spend_score(30)
	assert_false(ok, "spending with insufficient score should be rejected")
	assert_eq(GameManager.score, 10, "score must NOT be deducted on rejection")

func test_spend_exact_amount():
	GameManager.add_score(50)
	var ok = GameManager.spend_score(50)
	assert_true(ok)
	assert_eq(GameManager.score, 0, "spending the exact amount leaves 0")

func test_score_changed_signal_emitted():
	watch_signals(GameManager)
	GameManager.add_score(5)
	assert_signal_emitted_with_parameters(GameManager, "score_changed", [5])

# ============ CLICK POWER ============

func test_base_click_power_is_one():
	assert_eq(GameManager.total_click_power, 1, "base power without bonuses = 1")

func test_additive_bonus():
	GameManager.add_additive_bonus(5)
	assert_eq(GameManager.total_click_power, 6, "1 + 5 = 6")

func test_multiplicative_bonus():
	GameManager.add_multiplicative_bonus(3.0)
	assert_eq(GameManager.total_click_power, 3, "1 * 3 = 3")

func test_bonus_order_additive_before_multiplicative():
	# This test LOCKS IN a design decision:
	# additive bonuses are applied BEFORE multiplicative ones.
	# If someone changes the order in _recalculate_click_power, this fails.
	GameManager.add_additive_bonus(4)
	GameManager.add_multiplicative_bonus(2.0)
	assert_eq(GameManager.total_click_power, 10, "(1+4)*2 = 10, not 1*2+4 = 6")

func test_multiple_additive_bonuses():
	GameManager.add_additive_bonus(2)
	GameManager.add_additive_bonus(3)
	assert_eq(GameManager.total_click_power, 6, "1+2+3 = 6")

func test_remove_additive_bonus():
	GameManager.add_additive_bonus(5)
	var removed = GameManager.remove_additive_bonus(5)
	assert_true(removed, "an existing bonus should be removable")
	assert_eq(GameManager.total_click_power, 1, "power returned to base")

func test_remove_nonexistent_bonus():
	var removed = GameManager.remove_additive_bonus(999)
	assert_false(removed, "removing a nonexistent bonus returns false")
	assert_eq(GameManager.total_click_power, 1, "power unchanged")

func test_remove_multiplicative_bonus():
	GameManager.add_multiplicative_bonus(2.0)
	GameManager.remove_multiplicative_bonus(2.0)
	assert_eq(GameManager.total_click_power, 1, "back to base after removing multiplier")

func test_click_power_changed_signal():
	watch_signals(GameManager)
	GameManager.add_additive_bonus(1)
	assert_signal_emitted(GameManager, "click_power_changed")

# ============ TICKETS ============

func test_add_tickets():
	GameManager.add_tickets(3)
	assert_eq(GameManager.tickets, 3)

func test_tickets_signal():
	watch_signals(GameManager)
	GameManager.add_tickets(2)
	assert_signal_emitted_with_parameters(GameManager, "tickets_changed", [2])

func test_reset_game_clears_score_and_tickets():
	GameManager.add_score(500)
	GameManager.add_tickets(5)
	GameManager.reset_game()
	assert_eq(GameManager.score, 0, "reset clears score")
	assert_eq(GameManager.tickets, 0, "reset clears tickets")
