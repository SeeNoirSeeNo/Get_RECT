extends Node2D

@onready var objectSpawner = $objectSpawner
@onready var bloodScan = $BloodScan
@onready var soundcontroller = $Sound_controller
@onready var scoreboard = $Control/Scoreboard
@onready var stage_timer = $stage_timer

func _ready():
	#Signals
	scoreboard.enter_next_stage.connect(self._on_next_stage_pressed)
	var track_names = soundcontroller.tracks.keys()
	var track_name = track_names.pick_random()
	Global.node_creation_parent = self
	Global.current_stage = 1
	Global.play_music(track_name, -20)

func _exit_tree():
	Global.node_creation_parent = null


func _on_stage_timer_timeout():
	objectSpawner.stop_spawning()
	stage_timer.stop()


func _on_next_stage_pressed():
	Global.current_stage += 1
	stage_timer.start()
	objectSpawner.start_spawning()
	


func _on_arena_inside_area_entered(area):
	if area.get_parent().is_in_group("enemies"):
		area.get_parent().add_to_group("in_arena")


func _on_arena_inside_area_exited(area):
	if area.get_parent().is_in_group("enemies"):
		area.get_parent().remove_from_group("in_arena")
