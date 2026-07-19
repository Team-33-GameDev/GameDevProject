extends StaticBody3D


func click() -> void:
	var victory_room := get_parent()

	if victory_room != null and victory_room.has_method("trigger_screamer"):
		victory_room.trigger_screamer()
	else:
		push_error(
			"CakeHitbox: VictoryRoom.trigger_screamer() was not found."
		)
