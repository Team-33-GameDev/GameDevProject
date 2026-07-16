extends PanelContainer
class_name FactorySlotUI


@onready var factory_name: Label = \
	$FactorySlot/Label

@onready var upgrades_container: VBoxContainer = \
	$FactorySlot/UpgradesContainer

@onready var buy_button: Button = \
	$FactorySlot/BuyButton


var factory_manager: FactoryManager
var factory: Factory
var factory_index: int = -1


func _ready() -> void:
	# Слот ещё не получил backend.
	buy_button.show()
	buy_button.disabled = true
	buy_button.text = ""

	upgrades_container.hide()

	if not buy_button.pressed.is_connected(
		_on_buy_pressed
	):
		buy_button.pressed.connect(
			_on_buy_pressed
		)


func setup(
	manager: FactoryManager,
	index: int
) -> void:
	factory_manager = manager
	factory_index = index

	if factory_manager == null:
		_set_unavailable("NO MANAGER")
		push_error(
			"FactorySlotUI: FactoryManager is null."
		)
		return

	factory = factory_manager.get_factory(factory_index)

	if factory == null:
		_set_unavailable("NO FACTORY")
		push_error(
			"FactorySlotUI: factory %d was not found."
			% factory_index
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


func _on_buy_pressed() -> void:
	if factory_manager == null or factory == null:
		return

	print(
		"Factory UI: trying to buy factory %d."
		% factory_index
	)

	var success: bool = factory_manager.buy_factory(
		factory_index
	)

	if not success:
		print(
			"Factory UI: purchase failed for factory %d."
			% factory_index
		)

	_refresh()


func _on_factory_updated(
	_updated_factory: Factory
) -> void:
	# Обновляемся при любом изменении менеджера.
	# Позже это автоматически разблокирует следующий слот.
	_refresh()


func _on_score_changed(
	_new_score: int
) -> void:
	# Кнопка становится доступной сразу после того,
	# как игрок накопил достаточно средств.
	_refresh()


func _refresh() -> void:
	if factory_manager == null or factory == null:
		_set_unavailable("NO FACTORY")
		return

	if factory.data == null:
		_set_unavailable("NO DATA")
		return

	if factory.template_data == null:
		_set_unavailable("NO TEMPLATE")
		return

	var purchased: bool = factory.data.is_purchased

	buy_button.visible = not purchased
	upgrades_container.visible = purchased

	if purchased:
		return

	var unlocked: bool = \
		factory_manager.is_factory_unlocked(
			factory_index
		)

	if not unlocked:
		buy_button.text = "LOCKED"
		buy_button.disabled = true
		return

	if not factory.template_data.can_buy:
		buy_button.text = "UNAVAILABLE"
		buy_button.disabled = true
		return

	var price: int = factory.template_data.item_price

	buy_button.text = "BUY\n%d" % price
	buy_button.disabled = not GameManager.has_score(price)


func _set_unavailable(message: String) -> void:
	buy_button.show()
	buy_button.disabled = true
	buy_button.text = message

	upgrades_container.hide()


func set_factory_name(new_name: String) -> void:
	factory_name.text = new_name
