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

func test_first_quota_is_30():
	# Locks in the balance: if someone changes the first quota,
	# this test reminds them to update the docs and this file too
	assert_eq(QuotaManager.quotas[0][1], 30, "first quota = 30 points")
	assert_eq(QuotaManager.quotas[0][0], 10.0, "first quota time = 10 sec")

# ============ RUN START ============

func test_first_click_starts_run():
	GameManager.add_score(1)  # first click
	assert_eq(QuotaManager.current_state, QuotaManager.GameState.RUNNING,
		"first score change from IDLE should start a run")

func test_run_sets_timer_and_target():
	GameManager.add_score(1)
	assert_eq(QuotaManager.current_quota_target, 30, "target = first quota")
	assert_almost_eq(QuotaManager.time_left, 10.0, 0.1, "timer = 10 sec")

func test_run_started_signal():
	watch_signals(QuotaManager)
	GameManager.add_score(1)
	assert_signal_emitted(QuotaManager, "run_started")

func test_score_change_during_run_does_not_restart():
	GameManager.add_score(1)
	var time_before = QuotaManager.time_left
	# simulate some elapsed time so the timer moves
	QuotaManager._process(1.0)
	GameManager.add_score(5)  # clicks during the run
	assert_almost_eq(QuotaManager.time_left, time_before - 1.0, 0.01,
		"clicks during a run must not restart the timer")

# ============ TIMER ============

func test_process_decreases_timer():
	GameManager.add_score(1)
	QuotaManager._process(3.0)
	assert_almost_eq(QuotaManager.time_left, 7.0, 0.01, "10 - 3 = 7")

func test_timer_does_not_tick_in_idle():
	var before = QuotaManager.time_left
	QuotaManager._process(5.0)
	assert_eq(QuotaManager.time_left, before,
		"the timer must not tick in IDLE")

# ============ SUCCESSFUL QUOTA COMPLETION ============

func test_quota_success_advances_index():
	GameManager.add_score(1)      # start the run
	GameManager.add_score(29)     # reach 30
	QuotaManager._process(10.1)   # time is up
	assert_eq(QuotaManager.current_quota_index, 1,
		"success advances the quota index")

func test_quota_success_resets_score():
	GameManager.add_score(30)
	QuotaManager._process(10.1)
	assert_eq(GameManager.score, 0, "score burns after a completed quota")

func test_quota_success_returns_to_idle():
	GameManager.add_score(30)
	QuotaManager._process(10.1)
	assert_eq(QuotaManager.current_state, QuotaManager.GameState.IDLE,
		"after success — preparation phase (IDLE)")

func test_quota_success_emits_signals():
	GameManager.add_score(30)
	watch_signals(QuotaManager)
	QuotaManager._process(10.1)
	assert_signal_emitted_with_parameters(QuotaManager, "run_ended", [true])
	assert_signal_emitted(QuotaManager, "preparation_phase_started")

func test_second_quota_is_100():
	GameManager.add_score(30)
	QuotaManager._process(10.1)   # complete the first quota
	GameManager.add_score(1)      # start the second run
	assert_eq(QuotaManager.current_quota_target, 100,
		"second quota = 100")

func test_overshoot_counts_as_success():
	GameManager.add_score(500)    # clicked far beyond the quota
	QuotaManager._process(10.1)
	assert_eq(QuotaManager.current_quota_index, 1,
		"overshooting is also a success")

# ============ RESET ============

func test_reset_game_restores_everything():
	GameManager.add_score(30)
	QuotaManager._process(10.1)   # completed a quota, index=1
	QuotaManager.reset_game()
	assert_eq(QuotaManager.current_quota_index, 0)
	assert_eq(QuotaManager.current_state, QuotaManager.GameState.IDLE)
	assert_eq(GameManager.score, 0)
