extends GutTest
# QuotaManager tests: state machine, run start, quota completion.
#
# IMPORTANT: we do NOT test quota failure (_trigger_game_over),
# because it calls change_scene_to_file — that would unload the GUT
# test scene and break the run. Failure is covered by the manual
# checklist in TESTING.md.

func before_each():
	QuotaManager.reset_game()

func after_all():
	QuotaManager.reset_game()

# ============ INITIAL STATE ============

func test_initial_state_is_idle():
	assert_eq(QuotaManager.current_state, QuotaManager.GameState.IDLE)

func test_initial_quota_index_zero():
	assert_eq(QuotaManager.current_quota_index, 0)

func test_first_quota_is_100():
	# Locks in the balance: if someone changes the first quota,
	# this test reminds them to update the docs and this file too
	assert_eq(QuotaManager.quotas[0][1], 100, "first quota = 100 points")
	assert_eq(QuotaManager.quotas[0][0], 30.0, "first quota time = 30 sec")

# ============ RUN START ============

func test_first_click_starts_run():
	GameManager.click(1)  # first active click
	assert_eq(QuotaManager.current_state, QuotaManager.GameState.RUNNING,
		"first active click from IDLE should start a run")

func test_run_sets_timer_and_target():
	GameManager.click(1)
	assert_eq(QuotaManager.current_quota_target, 100, "target = first quota")
	assert_almost_eq(QuotaManager.time_left, 30.0, 0.1, "timer = 30 sec")

func test_run_started_signal():
	watch_signals(QuotaManager)
	GameManager.click(1)
	assert_signal_emitted(QuotaManager, "run_started")

func test_score_change_during_run_does_not_restart():
	GameManager.click(1)
	var time_before = QuotaManager.time_left
	# simulate some elapsed time so the timer moves
	QuotaManager._process(1.0)
	GameManager.add_score(5)  # clicks during the run
	assert_almost_eq(QuotaManager.time_left, time_before - 1.0, 0.01,
		"clicks during a run must not restart the timer")

# ============ TIMER ============

func test_process_decreases_timer():
	GameManager.click(1)
	QuotaManager._process(3.0)
	assert_almost_eq(QuotaManager.time_left, 27.0, 0.01, "30 - 3 = 27")

func test_timer_does_not_tick_in_idle():
	var before = QuotaManager.time_left
	QuotaManager._process(5.0)
	assert_eq(QuotaManager.time_left, before,
		"the timer must not tick in IDLE")

# ============ SUCCESSFUL QUOTA COMPLETION ============

func test_quota_success_advances_index():
	GameManager.click(1)          # start the run
	GameManager.add_score(99)     # reach 100
	QuotaManager._process(30.1)   # time is up
	assert_eq(QuotaManager.current_quota_index, 1,
		"success advances the quota index")

func test_quota_success_keeps_surplus_score():
	GameManager.click(125)
	QuotaManager._process(30.1)
	assert_eq(GameManager.score, 25,
		"completed quota burns, surplus remains spendable")

func test_quota_success_returns_to_idle():
	GameManager.click(100)
	QuotaManager._process(30.1)
	assert_eq(QuotaManager.current_state, QuotaManager.GameState.IDLE,
		"after success — preparation phase (IDLE)")

func test_quota_success_emits_signals():
	GameManager.click(100)
	watch_signals(QuotaManager)
	QuotaManager._process(30.1)
	assert_signal_emitted_with_parameters(QuotaManager, "run_ended", [true])
	assert_signal_emitted(QuotaManager, "preparation_phase_started")

func test_second_quota_is_200():
	GameManager.click(100)
	QuotaManager._process(30.1)   # complete the first quota
	GameManager.click(1)          # start the second run
	assert_eq(QuotaManager.current_quota_target, 200,
		"second quota = 200")

func test_campaign_has_four_balanced_quotas():
	assert_eq(QuotaManager.quotas.size(), 4)
	assert_eq(QuotaManager.quotas[2], [30.0, 800])
	assert_eq(QuotaManager.quotas[3], [30.0, 1500])

func test_quota_reduction_is_limited_to_thirty_percent():
	GameManager.click(1)
	for _attempt in range(20):
		QuotaManager.decrease_quota(0.05)
	assert_eq(QuotaManager.current_quota_target, 70,
		"the big button cannot replace earning score")

func test_quota_cannot_be_reduced_during_preparation():
	assert_false(QuotaManager.decrease_quota(0.05))
	assert_eq(QuotaManager.current_quota_target, 0)

func test_overshoot_counts_as_success():
	GameManager.click(500)        # clicked far beyond the quota
	QuotaManager._process(30.1)
	assert_eq(QuotaManager.current_quota_index, 1,
		"overshooting is also a success")
	assert_eq(GameManager.score, 400,
		"overshoot becomes the preparation budget")

# ============ RESET ============

func test_reset_game_restores_everything():
	GameManager.click(100)
	QuotaManager._process(30.1)   # completed a quota, index=1
	QuotaManager.reset_game()
	assert_eq(QuotaManager.current_quota_index, 0)
	assert_eq(QuotaManager.current_state, QuotaManager.GameState.IDLE)
	assert_eq(GameManager.score, 0)
