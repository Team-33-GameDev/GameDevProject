class_name BaseClick extends IClickAction

@export var clickValue: int = 10

func getValue() -> int:
	if clickValue > 0:
		return clickValue
	return -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var action: IClickAction = BaseClick.new()
	#action = AddClickBonus.new(action, 5)
	#action = MultiplyClickBonus.new(action, 2)
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
