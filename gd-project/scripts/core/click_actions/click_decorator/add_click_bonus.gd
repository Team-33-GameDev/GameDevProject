class_name AddClickBonus extends ClickDecorator

var _bonus: int
func _init(wrappee: IClickAction, bonus: int) -> void:
	super(wrappee)
	_bonus = bonus

func getValue() -> int:
	return _wrappee.getValue() + _bonus
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
