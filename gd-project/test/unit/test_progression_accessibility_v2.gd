extends GutTest


const ManagerScript = preload(
	"res://scripts/globals/progression_accessibility_manager.gd"
)


func test_interaction_prompt_contains_control_and_action() -> void:
	assert_eq(
		ManagerScript.format_interaction_prompt("E", "open door"),
		"[E]  OPEN DOOR"
	)
	assert_eq(
		ManagerScript.format_interaction_prompt("LMB", "open screen"),
		"[LMB]  OPEN SCREEN"
	)


func test_subtitle_timeline_covers_entire_voice_recording() -> void:
	assert_false(
		ManagerScript.get_boss_subtitle_for_time(0.0).is_empty()
	)
	assert_false(
		ManagerScript.get_boss_subtitle_for_time(20.95).is_empty()
	)
	assert_eq(
		ManagerScript.get_boss_subtitle_for_time(21.1),
		""
	)
