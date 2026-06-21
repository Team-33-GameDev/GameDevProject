extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	text = "Score: %s" % GameManager.score
	GameManager.score_changed.connect(_on_score_changed)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_score_changed(new_score: int):
	text = "Score: %s" % new_score
	animate_bounce()
	
func animate_bounce():
	pivot_offset = size / 2
	
	# Создаем новый Tween для анимации
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.05)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)

	
