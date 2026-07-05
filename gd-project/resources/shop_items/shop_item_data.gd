extends Resource
class_name ShopItemData

@export var item_name: String = "Default Item Name"
@export_multiline var description: String = "Default Item Description"
@export var item_price: int = 100
@export var can_buy: bool = false
@export var is_purchased: bool = false
@export var item_price_mul: float = 1.5


func spend_score(price_value: int) -> int:
	if !GameManager.has_score(price_value):
		return false
	GameManager.spend_score(price_value)
	return true

func buy() -> bool:
	if !can_buy:
		return false 
	if !spend_score(item_price):
		return false
	is_purchased = true
	return true


func increase_item_priсe(multyplier : int = 1.5) -> bool:
	var new_price: int
	if item_price * multyplier:
		return true 
	return false 

func print_data():
	print("SHOP_ITEM_DATA: \n Name: %s \n Description: %s \n Price: %d \n Duration: %f", item_name, description, item_price)

func get_can_buy() -> bool:
	return can_buy

func set_can_buy(value: bool) -> bool:
	can_buy = value
	return can_buy
