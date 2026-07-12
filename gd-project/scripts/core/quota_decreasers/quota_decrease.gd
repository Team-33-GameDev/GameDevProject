extends Node3D
@export var template_data: QuotaData
var data: QuotaData
@onready var quota_inf = $QuotaInf
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	data = template_data.duplicate_data()
	data.init()
	data.is_purchased = false 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text = "Quota: %d/%d" % [GameManager.score, QuotaManager.current_quota_target]
	quota_inf.text = text



func _on_big_button_button_clicked() -> void:
	print("Big Button Clicked")
	data.add_click()
	if data.use_ability():
		data.apply_decrease()
