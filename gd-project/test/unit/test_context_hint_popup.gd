extends GutTest


const ContextPopup = preload(
	"res://scripts/components/ui/context_hint_popup.gd"
)
const POPUP_SCENE = preload(
	"res://scenes/ui/context_hint_popup.tscn"
)


func test_hint_catalogue_contains_core_gameplay_topics() -> void:
	var required_hints: Array[StringName] = [
		&"induction",
		&"active_quota",
		&"preparation",
		&"shop",
		&"factory",
		&"crowbar",
		&"sledgehammer",
		&"big_button",
	]

	for hint_id: StringName in required_hints:
		var hint: Dictionary = ContextPopup.get_hint_content(
			hint_id
		)
		assert_false(hint.is_empty(), str(hint_id))
		assert_true(hint.has("title"), str(hint_id))
		assert_true(hint.has("body"), str(hint_id))
		assert_true(hint.has("color"), str(hint_id))


func test_unknown_hint_is_ignored() -> void:
	assert_true(
		ContextPopup.get_hint_content(&"unknown").is_empty()
	)


func test_popup_scene_has_non_blocking_responsive_shell() -> void:
	var popup := POPUP_SCENE.instantiate() as ContextHintPopup
	add_child_autofree(popup)

	var screen := popup.get_node("Screen") as Control
	var window := popup.get_node(
		"Screen/PopupWindow"
	) as PanelContainer

	assert_not_null(screen)
	assert_not_null(window)
	assert_eq(screen.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	assert_eq(window.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	assert_eq(popup.layer, 120)
