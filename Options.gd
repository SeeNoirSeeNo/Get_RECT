extends Panel

@onready var difficultyLabelSTR = $MarginContainer/VBoxContainer/difficultyLabelSTR
@onready var screenShakeSTR = $MarginContainer/VBoxContainer/screenShakeSTR

var difficulty = [
	"Error 404: Difficulty not found",
	"Very easy",
	"Easy",
	"You could at least try",
	"Slowly getting there",
	"This is acceptable",
	"You dare?",
	"Are you sure about 'dis?",
	"This is a mistake",
	"100% REGRET"
]

func _ready():
	Global.play_sound("8bit_idee")
	difficultyLabelSTR.self_modulate = Global.pickRandomColor()


func _on_on_pressed():
	Global.music_turned_off = false
	Global.play_sound("8bit_idee")


func _on_off_pressed():
	Global.music_turned_off = true
	Global.stop_sound("8bit_idee")


func _on_h_slider_value_changed(value):
	Global.difficulty_setting = int(value)
	difficultyLabelSTR.text = difficulty[value-1]
	difficultyLabelSTR.self_modulate = Global.pickRandomColor()


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menu.tscn")


func _on_screen_shake_slider_value_changed(value):
	Global.screenShakeIntensity = int(value)
	screenShakeSTR.text = str(value)
	screenShakeSTR.self_modulate = Global.pickRandomColor()


func _on_check_button_toggled(button_pressed):
	Global.chaosMode = button_pressed
