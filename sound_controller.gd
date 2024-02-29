extends Node2D

@onready var stage_music = $stage_music

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.sound_controller = self
	Global.score_updated.connect(self._on_score_updated)

func _exit_tree():
	Global.sound_controller = null
	Global.score_updated.disconnect(self._on_score_updated)

func _on_score_updated():
	var new_speed = 1.0 + Global.score / 5000000.0  # Adjust this formula as needed
	stage_music.pitch_scale = new_speed
	print(stage_music.pitch_scale)
