extends Node

signal score_changed(new_score: int) 
var score: int = 0:
	set(value):
		score = value
		score_changed.emit(score)
		print("game_manager: Score ", score)
		

func add_score(amount: int) -> void:
	score += amount
	print("game_manager: add_score() was called")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var tickets: int = 0
signal tickets_changed(new_amount: int)

func add_tickets(amount: int) -> void:
	tickets += amount
	tickets_changed.emit(tickets)
	
	
func reset_game() -> void:
	score = 0
	tickets = 0
	score_changed.emit(score)
