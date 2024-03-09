extends Node2D

@onready var tracks = {
	"Track0": $Track0,
	"Track1": $Track1,
	"Track2": $Track2,
	"Track3": $Track3,
	"Track4": $Track4,
	"Track5": $Track5,
	"Track6": $Track6,
	"Track7": $Track7,
	"Track8": $Track8,
	"Track9": $Track9,
	"Track10": $Track10
}

var current_track = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.sound_controller = self
	Global.score_updated.connect(self._on_score_updated)

func _exit_tree():
	Global.sound_controller = null
	Global.score_updated.disconnect(self._on_score_updated)

func _on_score_updated():
	if current_track != null:
		var new_speed = 1.0 + Global.score / 50000.0  # Adjust this formula as needed
		current_track.pitch_scale = new_speed
