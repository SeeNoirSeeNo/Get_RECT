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

func _process(delta):
	#print("Stage Timer", stage_timer.get_time_left())
	pass
func _exit_tree():
	Global.node_creation_parent = null


func _on_stage_timer_timeout():
	objectSpawner.stop_spawning()
	stage_timer.stop()


func _on_next_stage_pressed():
	Global.current_stage += 1
	stage_timer.start()
	objectSpawner.start_spawning()
	
