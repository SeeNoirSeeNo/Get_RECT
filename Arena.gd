extends Node2D

@onready var bloodScan = $BloodScan

func _ready():
	Global.node_creation_parent = self
	Global.score = 0
	Global.play_sound("stage_music")

func _exit_tree():
	Global.node_creation_parent = null
