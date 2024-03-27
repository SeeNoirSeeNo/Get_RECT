extends Control

signal shop_values_updated

@onready var skillpoints_int = $Panel/VBoxContainer/PanelContainer/HBoxContainer/skillpoints_INT


func _process(delta):
	skillpoints_int.text = str(PlayerSkills.skillpoints)


func _on_new_run_pressed():
	get_tree().change_scene_to_file("res://arena.tscn")
