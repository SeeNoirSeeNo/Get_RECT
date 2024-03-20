extends Node

signal score_updated
signal stage_changed(new_stage)

###//ARENA//###
var arena_offset_left = 645
var arena_offset_right = 635
var arena_offset_bottom = 360
var arena_offset_top = 360
###//SETUP//###
var node_creation_parent = null
var player = null
var sound_controller = null
var camera = null
###//OPTIONS//###
var screenShakeIntensity = 100
var music_turned_off = false
var difficulty_setting = 1
var spawn_multiplicator = 1
var chaosMode = false
###//GAME//###
var _current_stage = 1
var current_stage:
	get:
		return _current_stage
	set(value):
		_current_stage = value
		emit_signal("stage_changed", _current_stage)
###//SCORE//###
var _score = 0
var score:
	get:
		return _score
	set(value):
		_score = value
		emit_signal("score_updated")
		
###//KILLBOUNTY//###
var _killBounty = 0
var killBounty:
	get:
		return _killBounty
	set(value):
		_killBounty = value
		score = _pixels + _killBounty

###//PIXELS//####
var _pixels = 0
var pixels:
	get:
		return _pixels
	set(value):
		_pixels = value
		score = _pixels + _killBounty

###//PERCENT//###
var _coverage = 0
var coverage:
	get:
		return _coverage
	set(value):
		_coverage = value

var highscoreScore = 0
var highscoreKillBounty = 0
var highscorePixels = 0
var highscoreCoverage = 0

func instance_node(node,location,parent):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func play_sound(sound, volume = 0.0, pitch = 0.0):
	if sound_controller != null and music_turned_off == false:
		if sound_controller.has_node(sound):
			sound_controller.get_node(sound).volume_db += volume
			sound_controller.get_node(sound).pitch_scale += pitch
			sound_controller.get_node(sound).play()

func stop_sound(sound):
	if sound_controller != null:
		if sound_controller.has_node(sound):
			sound_controller.get_node(sound).stop()

func play_music(name, volume = 0.0):
	if sound_controller != null and music_turned_off == false:
		if name in sound_controller.tracks:
			if sound_controller.current_track:
				sound_controller.current_track.stop()
			sound_controller.current_track = sound_controller.tracks[name]
			sound_controller.current_track.volume_db += volume
			sound_controller.current_track.play()

###//UTILITY//###
func pickRandomColor():
	var new_color = Color(randf(), randf(), randf(), 1.0)
	return new_color
