extends Node3D
@export var template_data: QuotaData
var data: QuotaData


const REQUIRED_JUMPS: int = 3
const DECREASE_PERCENT: float = 0.05


signal jump_registered
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	data = template_data.duplicate_data()
	data.init()
	data.is_purchased = false

	# Restore the original Big Button behavior at runtime. This keeps
	# the mechanic stable even if an older balance resource is cached
	# or stores different tuning values.
	data.condition_click = REQUIRED_JUMPS
	data.q_decrease_percent = DECREASE_PERCENT



func _on_big_button_button_clicked() -> void:
	jump_registered.emit()
	print("Big Button Clicked")
	data.add_click()
	if data.use_ability():
		data.apply_decrease()
