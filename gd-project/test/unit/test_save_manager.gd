extends GutTest
# SaveManager tests: save/load roundtrip and corrupted files.
#
# NOTE: SaveManager writes to the real user://savegame.json.
# To avoid wiping the developer's own save, we back it up in before_all
# and restore it in after_all.
#
# Requires SaveManager.load_game() to use the instance-based JSON parser
# (JSON.new().parse(...)) — the static JSON.parse_string() prints an
# internal engine error on invalid input, which GUT treats as a failure.

const SAVE_PATH := "user://savegame.json"
const BACKUP_PATH := "user://savegame_test_backup.json"

var _had_real_save := false

func before_all():
	# Back up the developer's real save
	if FileAccess.file_exists(SAVE_PATH):
		_had_real_save = true
		DirAccess.copy_absolute(SAVE_PATH, BACKUP_PATH)

func after_all():
	# Restore the real save
	if _had_real_save:
		DirAccess.copy_absolute(BACKUP_PATH, SAVE_PATH)
		DirAccess.remove_absolute(BACKUP_PATH)
	else:
		if FileAccess.file_exists(SAVE_PATH):
			DirAccess.remove_absolute(SAVE_PATH)
	QuotaManager.reset_game()

func before_each():
	# Clean state before each test
	SaveManager.delete_save()
	GameManager.score = 0
	GameManager.tickets = 0
	GameManager._additive_bonuses.clear()
	GameManager._multiplicative_bonuses.clear()
	GameManager._recalculate_click_power()
	QuotaManager.current_quota_index = 0
	# GAME_OVER so score changes in tests don't start a run.
	# (QuotaManager listens to player clicks and starts the timer from IDLE,
	# which would trip the "no save mid-run" guard and break these tests.)
	QuotaManager.current_state = QuotaManager.GameState.GAME_OVER

# ============ BASICS ============

func test_no_save_initially():
	assert_false(SaveManager.has_save(), "no file should exist after delete_save")

func test_save_creates_file():
	SaveManager.save_game()
	assert_true(SaveManager.has_save(), "save_game should create the file")

func test_delete_save():
	SaveManager.save_game()
	SaveManager.delete_save()
	assert_false(SaveManager.has_save())

func test_load_without_file_returns_false():
	var ok = SaveManager.load_game()
	assert_false(ok, "loading without a file should return false, not crash")

# ============ ROUNDTRIP: SAVE -> CORRUPT STATE -> LOAD ============

func test_roundtrip_quota_index():
	QuotaManager.current_quota_index = 2
	SaveManager.save_game()
	QuotaManager.current_quota_index = 0  # corrupt in-memory state
	var ok = SaveManager.load_game()
	assert_true(ok)
	assert_eq(QuotaManager.current_quota_index, 2, "quota index restored")

func test_roundtrip_tickets():
	GameManager.tickets = 7
	SaveManager.save_game()
	GameManager.tickets = 0
	SaveManager.load_game()
	assert_eq(GameManager.tickets, 7, "tickets restored")

func test_roundtrip_bonuses():
	GameManager.add_additive_bonus(5)
	GameManager.add_multiplicative_bonus(2.0)
	SaveManager.save_game()
	GameManager._additive_bonuses.clear()
	GameManager._multiplicative_bonuses.clear()
	GameManager._recalculate_click_power()
	SaveManager.load_game()
	assert_eq(GameManager.total_click_power, 12,
		"(1+5)*2 = 12: bonuses restored and power recalculated")

func test_load_resets_score_to_zero():
	GameManager.score = 999
	SaveManager.save_game()
	GameManager.score = 555
	SaveManager.load_game()
	assert_eq(GameManager.score, 0,
		"score is not persisted — after loading the quota starts fresh")

# ============ GUARDS ============

func test_save_during_run_restarts_same_quota():
	QuotaManager.current_quota_index = 1
	QuotaManager.current_state = QuotaManager.GameState.IDLE
	GameManager.score = 0
	SaveManager.save_game()
	QuotaManager.current_state = QuotaManager.GameState.RUNNING
	GameManager.score = 999
	SaveManager.save_game()
	assert_true(SaveManager.has_save())
	QuotaManager.current_quota_index = 0
	SaveManager.load_game()
	assert_eq(QuotaManager.current_quota_index, 1,
		"Continue must restart the same quota")
	assert_eq(GameManager.score, 0,
		"unfinished clicking-phase score must not be restored")

func test_corrupted_save_returns_false():
	var f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_string("{this is not valid json!!")
	f.close()
	var ok = SaveManager.load_game()
	assert_false(ok, "garbage in the file must not crash the game")

func test_save_from_newer_version_rejected():
	var f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify({"version": 9999, "quota_index": 3}))
	f.close()
	var ok = SaveManager.load_game()
	assert_false(ok, "a save from a newer game version is rejected")

func test_missing_fields_use_defaults():
	# A save with only the version field — everything else missing
	var f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify({"version": 1}))
	f.close()
	var ok = SaveManager.load_game()
	assert_true(ok, "an incomplete but valid save should load")
	assert_eq(QuotaManager.current_quota_index, 0, "missing field -> default")
	assert_eq(GameManager.tickets, 0)

# ============ RESET_PROGRESS ============

func test_reset_progress_deletes_save():
	SaveManager.save_game()
	SaveManager.reset_progress()
	assert_false(SaveManager.has_save())

func test_reset_progress_clears_bonuses():
	GameManager.add_additive_bonus(10)
	SaveManager.reset_progress()
	assert_eq(GameManager.total_click_power, 1, "bonuses reset to base")

# ============ SIGNALS ============

func test_saved_signal():
	watch_signals(SaveManager)
	SaveManager.save_game()
	assert_signal_emitted(SaveManager, "game_saved")

func test_loaded_signal():
	SaveManager.save_game()
	watch_signals(SaveManager)
	SaveManager.load_game()
	assert_signal_emitted(SaveManager, "game_loaded")
