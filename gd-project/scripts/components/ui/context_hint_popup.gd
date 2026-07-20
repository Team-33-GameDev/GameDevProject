extends CanvasLayer
class_name ContextHintPopup


const DEFAULT_DURATION: float = 6.0
const SLIDE_DISTANCE: float = 48.0
const POPUP_MINIMUM_SIZE := Vector2(360.0, 224.0)
const CODE_FONT_SIZE: int = 22
const TITLE_FONT_SIZE: int = 36
const MESSAGE_FONT_SIZE: int = 27

const HINTS := {
	&"induction": {
		"code": "WORKER INDUCTION // 01",
		"title": "CONTROL PROTOCOL",
		"body": (
			"WASD — MOVE  //  MOUSE — LOOK\n"
			+ "Aim at a control and press LMB to operate it. "
			+ "Strike the production button to begin your quota."
		),
		"color": Color("77c9ff"),
	},
	&"active_quota": {
		"code": "PRODUCTION DIRECTIVE // 02",
		"title": "QUOTA ACTIVE",
		"body": (
			"Shop and factory terminals stay online. "
			+ "Purchases reduce quota progress, so leave enough "
			+ "score for inspection."
		),
		"color": Color("ffb454"),
	},
	&"preparation": {
		"code": "CLEARANCE NOTICE // 03",
		"title": "PREPARATION WINDOW",
		"body": (
			"Quota cleared. Your remaining score is available. "
			+ "Terminals pause production while you plan."
		),
		"color": Color("7dff9c"),
	},
	&"shop": {
		"code": "TERMINAL HELP // 04",
		"title": "UPGRADE TERMINAL",
		"body": (
			"Spend score on manual output upgrades. During a quota, "
			+ "every purchase lowers current progress."
		),
		"color": Color("77c9ff"),
	},
	&"factory": {
		"code": "TERMINAL HELP // 05",
		"title": "FACTORY CONTROL",
		"body": (
			"Factories produce automatically during quotas, "
			+ "but wear down. Use their green controls to restore HP."
		),
		"color": Color("77c9ff"),
	},
	&"crowbar": {
		"code": "EQUIPMENT NOTICE // 06",
		"title": "CROWBAR DISPENSED",
		"body": (
			"Equipment unlocked. Pick up the crowbar and "
			+ "break wooden barricades to reach restricted sectors."
		),
		"color": Color("7dff9c"),
	},
	&"upgrade": {
		"code": "PRODUCTION NOTICE // 07",
		"title": "OUTPUT INCREASED",
		"body": (
			"Manual production has been upgraded. "
			+ "Each strike now contributes more toward the quota."
		),
		"color": Color("7dff9c"),
	},
	&"big_button": {
		"code": "CONTINGENCY HELP // 08",
		"title": "QUOTA OVERRIDE",
		"body": (
			"Three jumps reduce the active quota by 5%. "
			+ "Total reduction is limited to 30% per quota."
		),
		"color": Color("ffb454"),
	},
	&"sledgehammer": {
		"code": "EQUIPMENT NOTICE // 09",
		"title": "SLEDGEHAMMER DISPENSED",
		"body": (
			"Heavy equipment unlocked. Pick up the sledgehammer "
			+ "with LMB, carry it to the brick wall, then throw it "
			+ "to open the Big Button sector."
		),
		"color": Color("7dff9c"),
	},
}


@export_range(2.0, 12.0, 0.5)
var display_duration: float = DEFAULT_DURATION

@onready var popup_window: PanelContainer = \
	$Screen/PopupWindow
@onready var accent: ColorRect = \
	$Screen/PopupWindow/Content/Accent
@onready var code_label: Label = \
	$Screen/PopupWindow/Content/BodyMargin/Body/Header/Code
@onready var title_label: Label = \
	$Screen/PopupWindow/Content/BodyMargin/Body/Title
@onready var message_label: Label = \
	$Screen/PopupWindow/Content/BodyMargin/Body/Message
@onready var progress_bar: ProgressBar = \
	$Screen/PopupWindow/Content/BodyMargin/Body/Footer/Progress


static var _shown_hint_ids: Dictionary = {}

var _hint_queue: Array[StringName] = []
var _active: bool = false
var _hiding: bool = false
var _time_remaining: float = 0.0
var _generation: int = 0
var _target_position: Vector2 = Vector2.ZERO
var _motion_tween: Tween = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 120
	_apply_readability_overrides()
	popup_window.hide()

	if not get_viewport().size_changed.is_connected(
		_apply_responsive_layout
	):
		get_viewport().size_changed.connect(
			_apply_responsive_layout
		)

	_connect_quota_signals()
	_apply_responsive_layout()
	call_deferred("_connect_scene_sources")
	call_deferred("_check_initial_hint")


func _apply_readability_overrides() -> void:
	popup_window.custom_minimum_size = POPUP_MINIMUM_SIZE
	code_label.add_theme_font_size_override(
		&"font_size",
		CODE_FONT_SIZE
	)
	title_label.add_theme_font_size_override(
		&"font_size",
		TITLE_FONT_SIZE
	)
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label.add_theme_font_size_override(
		&"font_size",
		MESSAGE_FONT_SIZE
	)


func _process(delta: float) -> void:
	if not _active or _hiding:
		return

	_time_remaining = maxf(_time_remaining - delta, 0.0)
	progress_bar.value = (
		_time_remaining / maxf(display_duration, 0.01)
	) * 100.0

	if is_zero_approx(_time_remaining):
		_start_hide()


static func get_hint_content(
	hint_id: StringName
) -> Dictionary:
	if not HINTS.has(hint_id):
		return {}

	return HINTS[hint_id]


func show_hint(
	hint_id: StringName,
	priority: bool = false
) -> void:
	if _shown_hint_ids.has(hint_id):
		return

	if get_hint_content(hint_id).is_empty():
		return

	_shown_hint_ids[hint_id] = true

	if priority:
		_hint_queue.clear()
		_hint_queue.push_front(hint_id)
		_interrupt_current_hint()
	else:
		_hint_queue.append(hint_id)

	if not _active:
		call_deferred("_display_next_hint")


func _connect_quota_signals() -> void:
	if not QuotaManager.run_started.is_connected(
		_on_run_started
	):
		QuotaManager.run_started.connect(
			_on_run_started
		)

	if not QuotaManager.preparation_phase_started.is_connected(
		_on_preparation_phase_started
	):
		QuotaManager.preparation_phase_started.connect(
			_on_preparation_phase_started
		)

	if not QuotaManager.boss_intro_state_changed.is_connected(
		_on_boss_intro_state_changed
	):
		QuotaManager.boss_intro_state_changed.connect(
			_on_boss_intro_state_changed
		)


func _connect_scene_sources() -> void:
	var current_scene: Node = get_tree().current_scene

	if current_scene == null:
		return

	var shop_backend := current_scene.get_node_or_null(
		"ShopSystem"
	) as Shop

	if shop_backend != null:
		if not shop_backend.click_upgraded.is_connected(
			_on_click_upgraded
		):
			shop_backend.click_upgraded.connect(
				_on_click_upgraded
			)

		if not shop_backend.crowbar_purchased.is_connected(
			_on_crowbar_purchased
		):
			shop_backend.crowbar_purchased.connect(
				_on_crowbar_purchased
			)

		if not shop_backend.sledgehammer_purchased.is_connected(
			_on_sledgehammer_purchased
		):
			shop_backend.sledgehammer_purchased.connect(
				_on_sledgehammer_purchased
			)

	var shop_station: Node = get_tree().get_first_node_in_group(
		&"click_shop_station"
	)
	_connect_signal_if_present(
		shop_station,
		&"shop_opened",
		_on_shop_opened
	)

	var factory_entity: Node = current_scene.find_child(
		"factory_manager_entity",
		true,
		false
	)
	_connect_signal_if_present(
		factory_entity,
		&"factory_manager_opened",
		_on_factory_manager_opened
	)

	var factory_backend := get_tree().get_first_node_in_group(
		&"factory_manager"
	) as FactoryManager

	if (
		factory_backend != null
		and not factory_backend.factory_updated.is_connected(
			_on_factory_updated
		)
	):
		factory_backend.factory_updated.connect(
			_on_factory_updated
		)

	var quota_override: Node = current_scene.find_child(
		"QuotaValueDecrease",
		true,
		false
	)
	_connect_signal_if_present(
		quota_override,
		&"jump_registered",
		_on_big_button_used
	)


func _connect_signal_if_present(
	source: Node,
	signal_name: StringName,
	callback: Callable
) -> void:
	if source == null or not source.has_signal(signal_name):
		return

	if not source.is_connected(signal_name, callback):
		source.connect(signal_name, callback)


func _check_initial_hint() -> void:
	if not QuotaManager.is_boss_intro_active():
		show_hint(&"induction", true)


func _on_boss_intro_state_changed(active: bool) -> void:
	if not active:
		show_hint(&"induction", true)


func _on_run_started() -> void:
	show_hint(&"active_quota", true)


func _on_preparation_phase_started() -> void:
	show_hint(&"preparation", true)


func _on_shop_opened() -> void:
	show_hint(&"shop")


func _on_factory_manager_opened() -> void:
	show_hint(&"factory")


func _on_crowbar_purchased() -> void:
	show_hint(&"crowbar")


func _on_sledgehammer_purchased() -> void:
	show_hint(&"sledgehammer")


func _on_click_upgraded(
	_upgrade_type: String
) -> void:
	show_hint(&"upgrade")


func _on_factory_updated(
	_factory: Factory
) -> void:
	show_hint(&"factory")


func _on_big_button_used() -> void:
	show_hint(&"big_button")


func _display_next_hint() -> void:
	if _active or _hint_queue.is_empty():
		return

	var hint_id: StringName = _hint_queue.pop_front()
	var hint: Dictionary = get_hint_content(hint_id)

	if hint.is_empty():
		call_deferred("_display_next_hint")
		return

	_generation += 1
	_active = true
	_hiding = false
	_time_remaining = display_duration

	code_label.text = str(hint["code"])
	title_label.text = str(hint["title"])
	message_label.text = str(hint["body"])

	var hint_color: Color = hint["color"]
	accent.color = hint_color
	code_label.add_theme_color_override(
		"font_color",
		hint_color
	)
	title_label.add_theme_color_override(
		"font_color",
		hint_color
	)

	progress_bar.value = 100.0
	popup_window.modulate.a = 0.0
	popup_window.position = (
		_target_position
		+ Vector2(SLIDE_DISTANCE, 0.0)
	)
	popup_window.show()

	_kill_motion_tween()
	_motion_tween = create_tween()
	_motion_tween.set_parallel(true)
	_motion_tween.set_trans(Tween.TRANS_QUART)
	_motion_tween.set_ease(Tween.EASE_OUT)
	_motion_tween.tween_property(
		popup_window,
		"position",
		_target_position,
		0.28
	)
	_motion_tween.tween_property(
		popup_window,
		"modulate:a",
		1.0,
		0.18
	)


func _start_hide() -> void:
	if not _active or _hiding:
		return

	_hiding = true
	var current_generation: int = _generation

	_kill_motion_tween()
	_motion_tween = create_tween()
	_motion_tween.set_parallel(true)
	_motion_tween.set_trans(Tween.TRANS_QUART)
	_motion_tween.set_ease(Tween.EASE_IN)
	_motion_tween.tween_property(
		popup_window,
		"position",
		_target_position + Vector2(SLIDE_DISTANCE, 0.0),
		0.22
	)
	_motion_tween.tween_property(
		popup_window,
		"modulate:a",
		0.0,
		0.18
	)
	_motion_tween.chain().tween_callback(
		_finish_hide.bind(current_generation)
	)


func _finish_hide(generation: int) -> void:
	if generation != _generation:
		return

	popup_window.hide()
	_active = false
	_hiding = false
	_motion_tween = null

	if not _hint_queue.is_empty():
		call_deferred("_display_next_hint")


func _interrupt_current_hint() -> void:
	if not _active:
		return

	_generation += 1
	_kill_motion_tween()
	popup_window.hide()
	_active = false
	_hiding = false


func _kill_motion_tween() -> void:
	if _motion_tween != null and _motion_tween.is_valid():
		_motion_tween.kill()

	_motion_tween = null


func _apply_responsive_layout() -> void:
	if popup_window == null:
		return

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var safe_margin: float = clampf(
		viewport_size.x * 0.025,
		16.0,
		32.0
	)
	var popup_width: float = clampf(
		viewport_size.x * 0.36,
		POPUP_MINIMUM_SIZE.x,
		580.0
	)

	popup_window.size.x = minf(
		popup_width,
		viewport_size.x - safe_margin * 2.0
	)
	popup_window.reset_size()
	popup_window.size.x = minf(
		popup_width,
		viewport_size.x - safe_margin * 2.0
	)

	_target_position = Vector2(
		viewport_size.x - popup_window.size.x - safe_margin,
		safe_margin
	)

	if not _active:
		popup_window.position = _target_position
