extends GutTest


func before_each() -> void:
	QuotaManager.reset_game()


func after_each() -> void:
	QuotaManager.reset_game()


func test_failed_attempt_reset_preserves_unfinished_quota() -> void:
	QuotaManager.current_quota_index = 4
	QuotaManager.current_state = QuotaManager.GameState.RUNNING
	QuotaManager.time_left = 12.0
	QuotaManager.current_quota_target = 1700
	QuotaManager._base_quota_target = 1700
	GameManager.score = 900

	QuotaManager._reset_failed_quota_attempt()

	assert_eq(QuotaManager.current_quota_index, 4)
	assert_eq(QuotaManager.current_state, QuotaManager.GameState.IDLE)
	assert_almost_eq(QuotaManager.time_left, 0.0, 0.001)
	assert_eq(QuotaManager.current_quota_target, 0)
	assert_eq(QuotaManager._base_quota_target, 0)
	assert_eq(GameManager.score, 0)


func test_first_quota_retry_remains_first_quota() -> void:
	QuotaManager.current_quota_index = 0

	QuotaManager._reset_failed_quota_attempt()

	assert_eq(QuotaManager.current_quota_index, 0)


func test_failed_retry_does_not_replay_boss_intro() -> void:
	assert_true(QuotaManager.should_play_boss_intro())

	QuotaManager.mark_boss_intro_completed()
	QuotaManager.current_quota_index = 2
	QuotaManager._reset_failed_quota_attempt()

	assert_false(QuotaManager.should_play_boss_intro())
	assert_eq(QuotaManager.current_quota_index, 2)


func test_new_game_restores_boss_intro() -> void:
	QuotaManager.mark_boss_intro_completed()
	QuotaManager.reset_game()

	assert_true(QuotaManager.should_play_boss_intro())
