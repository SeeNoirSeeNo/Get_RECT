extends "res://Enemy_core.gd"

func _process(delta):
	super(delta)
	basic_movement_towards_player(delta)

