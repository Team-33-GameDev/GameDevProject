extends Resource
class_name ShopItemData

@export var item_name: String
@export_multiline var description: String
@export var price: int

#@export var mesh_scene: PackedScene

func increase_prise(multyplier : int) -> bool:
	var new_price: int
	if price * multyplier:
		return true 
	return false 

func print_data():
	print("SHOP_ITEM_DATA: \n Name: %s \n Description: %s \n Price: %d \n Duration: %f", item_name, description, price)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
