extends Node2D

@onready var tracks = {
	"Qualle: WaveShooter": $Music/Track0,
	"DavidKBD: The desolation of a civilization": $Music/Track1,
	"DavidKBD: Agony Space-deep": $Music/Track2,
	"DavidKBD: I Can See You:": $Music/Track3,
	"DavidKBD: Eating offal": $Music/Track4,
	"DavidKBD: Evil soul inside": $Music/Track5,
	"DavidKBD: God of darkness": $Music/Track6,
	"DavidKBD: Suffocation": $Music/Track7,
	"DavidKBD: While We Sleep": $Music/Track8,
	"DavidKBD: Soul evisceration": $Music/Track9,
	"DavidKBD: Rotten Offal": $Music/Track10,
	"DavidKBD: Screams in the Distance": $Music/Track11,
	"DavidKBD: At the Gates": $Music/Track12,
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
	pass
#	if current_track != null:
#		var new_speed = 1.0 + Global.score / 50000.0  # Adjust this formula as needed
#		current_track.pitch_scale = new_speed
