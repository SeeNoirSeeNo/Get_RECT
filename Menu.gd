extends Panel

@onready var skillpoints_int = $MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/SkillpointsINT



func _ready():
	Global.play_sound("Track0")
	skillpoints_int.text = str(PlayerSkills.skillpoints)
	

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Shop.tscn")
	

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Options.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_upgrades_pressed():
	get_tree().change_scene_to_file("res://Shop.tscn")

