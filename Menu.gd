extends Panel




func _ready():
	Global.play_sound("8bit_idee")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://arena.tscn")
	

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Options.tscn")

func _on_quit_pressed():
	get_tree().quit()



