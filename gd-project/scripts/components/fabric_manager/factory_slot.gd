extends PanelContainer


# -------------------------------------------------------------------
# Узлы интерфейса
# -------------------------------------------------------------------

var factory_slot: VBoxContainer
var factory_name: Label
var upgrades_container: VBoxContainer

var buy_button: Button
var up_hp_button: Button
var up_cps_button: Button
var up_dps_button: Button
var up_restore_button: Button


# -------------------------------------------------------------------
# Связь с существующей системой фабрик
# -------------------------------------------------------------------

var factory_manager
var factory
var factory_index: int = -1

var _nodes_ready: bool = false


func _ready() -> void:
	if not _resolve_nodes():
		return

	_connect_buttons()
	_apply_original_button_style()

	# Исходный вид карточки:
	# большая BUY-кнопка и скрытые улучшения.
	buy_button.show()
	buy_button.disabled = true
	buy_button.text = "LOCKED"

	upgrades_container.hide()


# -------------------------------------------------------------------
# Поиск узлов
# -------------------------------------------------------------------

func _resolve_nodes() -> bool:
	factory_slot = get_node_or_null(
		"FactorySlot"
	) as VBoxContainer

	if factory_slot == null:
		push_error(
			"FactorySlot %s: child VBoxContainer "
			+ "'FactorySlot' was not found."
			% name
		)
		return false

	factory_name = factory_slot.get_node_or_null(
		"Label"
	) as Label

	upgrades_container = factory_slot.get_node_or_null(
		"UpgradesContainer"
	) as VBoxContainer

	buy_button = factory_slot.get_node_or_null(
		"BuyButton"
	) as Button

	if upgrades_container != null:
		up_hp_button = upgrades_container.get_node_or_null(
			"UpHP"
		) as Button

		up_cps_button = upgrades_container.get_node_or_null(
			"UpCPS"
		) as Button

		up_dps_button = upgrades_container.get_node_or_null(
			"UpDPS"
		) as Button

		up_restore_button = upgrades_container.get_node_or_null(
			"UpRestore"
		) as Button

	var missing_nodes: Array[String] = []

	if factory_name == null:
		missing_nodes.append("FactorySlot/Label")

	if upgrades_container == null:
		missing_nodes.append(
			"FactorySlot/UpgradesContainer"
		)

	if buy_button == null:
		missing_nodes.append(
			"FactorySlot/BuyButton"
		)

	if up_hp_button == null:
		missing_nodes.append(
			"FactorySlot/UpgradesContainer/UpHP"
		)

	if up_cps_button == null:
		missing_nodes.append(
			"FactorySlot/UpgradesContainer/UpCPS"
		)

	if up_dps_button == null:
		missing_nodes.append(
			"FactorySlot/UpgradesContainer/UpDPS"
		)

	if up_restore_button == null:
		missing_nodes.append(
			"FactorySlot/UpgradesContainer/UpRestore"
		)

	if not missing_nodes.is_empty():
		push_error(
			"FactorySlot %s: missing UI nodes: %s"
			% [name, ", ".join(missing_nodes)]
		)
		return false

	_nodes_ready = true
	return true


func _ensure_nodes() -> bool:
	if _nodes_ready:
		return true

	return _resolve_nodes()


# -------------------------------------------------------------------
# Подключение сигналов
# -------------------------------------------------------------------

func _connect_buttons() -> void:
	if not buy_button.pressed.is_connected(
		_on_buy_pressed
	):
		buy_button.pressed.connect(
			_on_buy_pressed
		)

	if not up_hp_button.pressed.is_connected(
		_on_up_hp_pressed
	):
		up_hp_button.pressed.connect(
			_on_up_hp_pressed
		)

	if not up_cps_button.pressed.is_connected(
		_on_up_cps_pressed
	):
		up_cps_button.pressed.connect(
			_on_up_cps_pressed
		)

	if not up_dps_button.pressed.is_connected(
		_on_up_dps_pressed
	):
		up_dps_button.pressed.connect(
			_on_up_dps_pressed
		)

	if not up_restore_button.pressed.is_connected(
		_on_up_restore_pressed
	):
		up_restore_button.pressed.connect(
			_on_up_restore_pressed
		)


# -------------------------------------------------------------------
# Настройка слота
# -------------------------------------------------------------------

func setup(manager, index: int) -> void:
	if not _ensure_nodes():
		return

	# На случай повторного setup() отключаем старый менеджер.
	if (
		factory_manager != null
		and factory_manager.has_signal("factory_updated")
		and factory_manager.factory_updated.is_connected(
			_on_factory_updated
		)
	):
		factory_manager.factory_updated.disconnect(
			_on_factory_updated
		)

	factory_manager = manager
	factory_index = index

	if factory_manager == null:
		_set_unavailable()
		push_error(
			"FactorySlot %s: FactoryManager is null."
			% name
		)
		return

	factory = factory_manager.get_factory(
		factory_index
	)

	if factory == null:
		_set_unavailable()
		push_error(
			"FactorySlot %s: factory with index %d was not found."
			% [name, factory_index]
		)
		return

	if not factory_manager.factory_updated.is_connected(
		_on_factory_updated
	):
		factory_manager.factory_updated.connect(
			_on_factory_updated
		)

	if not GameManager.score_changed.is_connected(
		_on_score_changed
	):
		GameManager.score_changed.connect(
			_on_score_changed
		)

	_refresh()


func show_unavailable(
	_message: String = ""
) -> void:
	if not _ensure_nodes():
		return

	factory_manager = null
	factory = null
	factory_index = -1

	_set_unavailable()


# -------------------------------------------------------------------
# Покупка фабрики
# -------------------------------------------------------------------

func _on_buy_pressed() -> void:
	if factory_manager == null or factory == null:
		return

	var success: bool = factory_manager.buy_factory(
		factory_index
	)

	if not success:
		print(
			"FactorySlot: purchase failed for index %d."
			% factory_index
		)

	_refresh()


# -------------------------------------------------------------------
# Покупка улучшений
# -------------------------------------------------------------------

func _on_up_hp_pressed() -> void:
	if factory_manager == null:
		return

	factory_manager.upgrade_hp(
		factory_index
	)

	_refresh()


func _on_up_cps_pressed() -> void:
	if factory_manager == null:
		return

	# В существующей системе этот метод увеличивает
	# click_value фабрики.
	factory_manager.upgrade_click(
		factory_index
	)

	_refresh()


func _on_up_dps_pressed() -> void:
	if factory_manager == null:
		return

	# Используем уже существующее улучшение damage.
	factory_manager.upgrade_damage(
		factory_index
	)

	_refresh()


func _on_up_restore_pressed() -> void:
	if factory_manager == null:
		return

	factory_manager.upgrade_rhpt(
		factory_index
	)

	_refresh()


# Этот метод оставлен только для совместимости со старым
# signal connection, сохранённым в factory_manager_screens.tscn.
# Настоящая покупка вызывается через _on_buy_pressed().
func _on_buy_button_pressed() -> void:
	pass


# -------------------------------------------------------------------
# Обновление по сигналам
# -------------------------------------------------------------------

func _on_factory_updated(
	updated_factory
) -> void:
	if updated_factory == factory:
		_refresh()
		return

	# После покупки предыдущей фабрики текущая может
	# разблокироваться, поэтому обновляем и другие слоты.
	if factory != null:
		_refresh()


func _on_score_changed(
	_new_score: int
) -> void:
	_refresh()


# -------------------------------------------------------------------
# Отображение состояния
# -------------------------------------------------------------------

func _refresh() -> void:
	if not _ensure_nodes():
		return

	if (
		factory_manager == null
		or factory == null
		or factory.data == null
		or factory.template_data == null
	):
		_set_unavailable()
		return

	var data = factory.data
	var template = factory.template_data
	var purchased: bool = data.is_purchased

	buy_button.visible = not purchased
	upgrades_container.visible = purchased

	if not purchased:
		_refresh_buy_button(template)
		return

	_refresh_upgrade_buttons(data)


func _refresh_buy_button(template) -> void:
	var price: int = template.item_price

	var unlocked: bool = factory_manager.is_factory_unlocked(
		factory_index
	)

	var available: bool = template.can_buy
	var enough_score: bool = GameManager.has_score(price)

	buy_button.show()
	buy_button.modulate = Color.WHITE
	buy_button.tooltip_text = ""

	# Фабрика ещё не открыта по последовательности.
	if not unlocked:
		_show_locked_state(
			"Buy the previous factory first."
		)
		return

	# Фабрика существует, но пока запрещена к покупке.
	if not available:
		_show_locked_state(
			"This factory is not available yet."
		)
		return

	# Доступная фабрика всегда сохраняет твой исходный дизайн:
	# BUY и цена внутри большой кнопки.
	buy_button.text = "BUY\n%d" % price
	buy_button.disabled = not enough_score

	if not enough_score:
		buy_button.tooltip_text = "Not enough score."

func _show_locked_state(
	tooltip: String = ""
) -> void:
	buy_button.show()
	buy_button.text = "LOCKED"
	buy_button.disabled = true
	buy_button.tooltip_text = tooltip

	# Не меняем фон, рамку, шрифт и размеры.
	# Используется исходный стиль кнопки из factory_slot.tscn.
	buy_button.modulate = Color.WHITE

func _refresh_upgrade_buttons(data) -> void:
	_update_upgrade_button(
		up_hp_button,
		"UP HP",
		data.cur_price_hp,
		data.upg_lvl_hp,
		data.max_lvl
	)

	_update_upgrade_button(
		up_cps_button,
		"UP CPS",
		data.cur_price_click,
		data.upg_lvl_click,
		data.max_lvl
	)

	_update_upgrade_button(
		up_dps_button,
		"UP DPS",
		data.cur_price_dmg,
		data.upg_lvl_dmg,
		data.max_lvl
	)

	_update_upgrade_button(
		up_restore_button,
		"UP RESTORE",
		data.cur_price_rhpt,
		data.upg_lvl_rhpt,
		data.max_lvl
	)


func _update_upgrade_button(
	button: Button,
	title: String,
	price: int,
	level: int,
	max_level: int
) -> void:
	if level >= max_level:
		button.text = "%s\nMAX" % title
		button.disabled = true
		button.tooltip_text = ""
		return

	button.text = "%s\n%d" % [title, price]
	button.disabled = not GameManager.has_score(price)

	if button.disabled:
		button.tooltip_text = "Not enough score."
	else:
		button.tooltip_text = ""


func _set_unavailable() -> void:
	if not _nodes_ready:
		return

	buy_button.show()
	buy_button.disabled = true
	buy_button.text = "LOCKED"
	buy_button.tooltip_text = ""
	buy_button.modulate = Color.WHITE

	upgrades_container.hide()


# -------------------------------------------------------------------
# Исходный дизайн disabled-состояния
# -------------------------------------------------------------------

func _apply_original_button_style() -> void:
	var buttons: Array[Button] = [
		buy_button,
		up_hp_button,
		up_cps_button,
		up_dps_button,
		up_restore_button
	]

	for button in buttons:
		if button == null:
			continue

		var normal_style: StyleBox = \
			button.get_theme_stylebox("normal")

		if normal_style != null:
			button.add_theme_stylebox_override(
				"disabled",
				normal_style
			)

		var normal_font_color: Color = \
			button.get_theme_color("font_color")

		button.add_theme_color_override(
			"font_disabled_color",
			normal_font_color
		)


func set_factory_name(
	new_name: String
) -> void:
	if not _ensure_nodes():
		return

	factory_name.text = new_name
