extends Node3D

class_name ShopSlot3D

@onready var spawn_point: Marker3D = $SpawnPoint
@onready var price_label: Label3D = $PriceLabel

#var current_item_data: ItemData
#var spawned_mesh: Node3D
#
#func set_item(data: ItemData) -> void:
	#current_item_data = data
	
	#if is_instance_valid(spawned_mesh):
		#spawned_mesh.queue_free()
		#
	#if current_item_data == null:
		#price_label.text = ""
		#return
	#spawned_mesh = current_item_data.mesh_scene.instantiate() as Node3D
	#spawn_point.add_child(spawned_mesh)
	#price_label.text = str(current_item_data.price) + " $"

func interact() -> void:
	print("shop_slot: take interection")
	#if current_item_data == null: return
	#if GameManager.try_purchase(current_item_data):
		#current_item_data = null
		#if is_instance_valid(spawned_mesh):
			#spawned_mesh.queue_free()
		#price_label.text = "Bought"

		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
