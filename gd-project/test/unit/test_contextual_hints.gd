extends GutTest


const TVDisplayScript = preload(
	"res://scripts/core/tv_display.gd"
)


var display


func before_each() -> void:
	display = TVDisplayScript.new()


func after_each() -> void:
	display.free()


func test_required_hint_catalog_is_complete() -> void:
	var required_ids: Array[StringName] = [
		&"begin_quota",
		&"active_quota",
		&"preparation",
		&"terminal_locked",
		&"crowbar",
		&"factory_maintenance",
		&"click_upgrade",
		&"big_button",
	]

	for hint_id: StringName in required_ids:
		assert_false(
			display._get_hint_text(hint_id).is_empty(),
			"missing contextual hint: %s" % hint_id
		)


func test_unknown_hint_is_ignored() -> void:
	assert_eq(
		display._get_hint_text(&"unknown_hint"),
		""
	)


func test_warning_hints_use_distinct_colors() -> void:
	assert_ne(
		display._get_hint_color(&"terminal_locked"),
		display._get_hint_color(&"begin_quota")
	)
	assert_ne(
		display._get_hint_color(&"factory_maintenance"),
		display._get_hint_color(&"begin_quota")
	)


func test_phase_changes_replace_stale_hints() -> void:
	assert_true(display._is_priority_hint(&"active_quota"))
	assert_true(display._is_priority_hint(&"preparation"))
	assert_true(display._is_priority_hint(&"terminal_locked"))
	assert_false(display._is_priority_hint(&"crowbar"))
