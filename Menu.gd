extends Panel

@onready var skillpoints_int = $MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/SkillpointsINT
@onready var power_up_damage = $MarginContainer/VBoxContainer/Powerup_container/Control/powerUp_Damage
@onready var power_up_shooting_speed = $MarginContainer/VBoxContainer/Powerup_container/Control2/powerUp_ShootingSpeed
@onready var power_up_wrap = $MarginContainer/VBoxContainer/Powerup_container/Control3/powerUp_Wrap

@onready var power_ups = [power_up_wrap]

func _ready():
	Global.play_sound("Track0")
	skillpoints_int.text = str(PlayerSkills.skillpoints)
	display_powerups()

func display_powerups():
	for power_up in power_ups:
		power_up.modulate.a = 1
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Shop.tscn")
	

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Options.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_upgrades_pressed():
	get_tree().change_scene_to_file("res://Shop.tscn")

