extends Node2D

@onready var bloodScan = $BloodScan
@onready var soundcontroller = $Sound_controller

func _ready():
	var track_names = soundcontroller.tracks.keys()
	var track_name = track_names.pick_random()
	Global.node_creation_parent = self
	Global.current_stage = 1
	Global.play_music(track_name, -20)

func _exit_tree():
	Global.node_creation_parent = null


func _on_stage_timer_timeout():
	Global.current_stage += 1
