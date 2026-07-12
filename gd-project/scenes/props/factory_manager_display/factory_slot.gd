extends PanelContainer

var factory_slot: VBoxContainer
var factory_name: Label
var upgrades_container: VBoxContainer
var buy_button: Button

# Состояние: куплена ли фабрика
var is_purchased: bool = false

func _ready() -> void:
	# Ищем узлы с учётом вложенности
	factory_slot = get_node_or_null("FactorySlot")
	
	if factory_slot:
		upgrades_container = factory_slot.get_node_or_null("UpgradesContainer")
		buy_button = factory_slot.get_node_or_null("BuyButton")
		factory_name = factory_slot.get_node_or_null("Label")
	else:
		push_warning(name + ": FactorySlot NOT FOUND!")
	
	# Диагностика
	if not upgrades_container:
		push_warning(name + ": UpgradesContainer NOT FOUND!")
	if not buy_button:
		push_warning(name + ": BuyButton NOT FOUND!")
	
	# Начальное состояние
	_update_visibility()
	
	# Подключаем сигнал клика
	if buy_button:
		buy_button.pressed.connect(_on_buy_pressed)

func _on_buy_pressed() -> void:
	is_purchased = true
	_update_visibility()
	print("✅ Factory purchased: ", name)

func _update_visibility() -> void:
	if buy_button:
		buy_button.visible = not is_purchased
	if upgrades_container:
		upgrades_container.visible = is_purchased

func set_purchased(purchased: bool) -> void:
	is_purchased = purchased
	_update_visibility()

# Метод для установки названия фабрики извне
func set_factory_name(new_name: String) -> void:
	if factory_name:
		factory_name.text = new_name
