class_name ClickDecorator extends IClickAction

var _wrappee: IClickAction
func _init(wrappee: IClickAction) -> void:
	_wrappee = wrappee
	
func getValue() -> int:
	assert(false, "Method getValue() must be overriden in cocrete Decorator")
	return 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
