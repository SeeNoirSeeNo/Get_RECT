extends Control
@onready var upgrade_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UpgradeButton

@onready var effect_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Panel/Effect_label

@onready var skillname = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Skillname
@onready var current_value_int = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CurrentValueINT
@onready var min_value_int = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MinValueINT
@onready var max_value_int = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MaxValueINT
@onready var slider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Slider

@export var text : String = "[color=red]Each level[/color] of this upgrade grants you [color=green]+10[/color] [color=yellow]movement speed[/color]"
@export var name_of_the_skill : String
@export var upgrade_increment : int
@export var upgrade_cost : int
@export var upgrade_cost_increase : int
@export var initial_min_value : int
@export var initial_max_value : int
@export var max_level : int

var skill_descriptions = {
	"Bullet damage" 	: "Increase your max damage by 1",
	"Bullet speed"		: "Increase your max bullet speed by 10",
	"Attack speed"		: "Increase your max attack speed by 10",
	"Movement speed" 	: "Increase your max movement speed by 5",
	"Stun power"		: "Increase your stun power by 5",
	"Splat size"		: "Increase the maximum size of blood splats enemy blood splatters",
	"Blood splats"		: "Increase the amount of individual blood splats when an enemy dies",
	"Powerup attackspeed": "Unlocks the 'Attackspeed' Powerup which will multiply your attackspeed by 3",
	"Powerup damage"	: "Unlocks the 'Damage' Powerup which will multiply your damage by 10",
	"Powerup wrap"		: "Unlocks the 'Wrap' Powerup which will make bullets wrap around the arena",
}

func _ready():
	set_init_values()
	update_slider_info()


func _process(delta):
	effect_label.text = text
	adjust_upgrade_color()

func set_init_values():
	skillname.text = name_of_the_skill #Init Skill Name
	if name_of_the_skill in skill_descriptions:
		text = skill_descriptions[name_of_the_skill]
	
	slider.min_value = initial_min_value # Init Min Value
	slider.max_value = initial_max_value + (PlayerSkills.skill_level[name_of_the_skill] * upgrade_increment)# Init Max Value
	upgrade_cost = (PlayerSkills.skill_level[name_of_the_skill] * upgrade_cost) + upgrade_cost
	update_upgrade_button_text()
	slider.value = slider.max_value

func update_slider_info():
	min_value_int.text = str(slider.min_value)
	min_value_int.self_modulate = Color("RED")
	max_value_int.text = str(slider.max_value)
	max_value_int.self_modulate = Color("GREEN")

func _on_upgrade_pressed():
	if PlayerSkills.skillpoints >= upgrade_cost and PlayerSkills.skill_level[name_of_the_skill] < max_level:
		PlayerSkills.skillpoints -= upgrade_cost
		slider.max_value += upgrade_increment
		update_slider_info()
		Global.play_sound("skill_bought")
		PlayerSkills.skill_level[name_of_the_skill] += 1
		update_skill_cost()
		update_upgrade_button_text()
		slider.value = slider.max_value
		_on_slider_value_changed(slider.value)
		#adjust_upgrade_color()

func update_skill_cost():
	upgrade_cost += upgrade_cost_increase

func update_upgrade_button_text():
	if PlayerSkills.skill_level[name_of_the_skill] < max_level:
		upgrade_button.text = "Upgrade to Level: " + str(PlayerSkills.skill_level[name_of_the_skill] + 1) + " for " + str(upgrade_cost)
	else:
		upgrade_button.text = "MAX LEVEL REACHED"

func adjust_upgrade_color():
	if PlayerSkills.skillpoints >= upgrade_cost and PlayerSkills.skill_level[name_of_the_skill] < max_level:
		upgrade_button.add_theme_color_override("font_color", Color("CYAN"))
		upgrade_button.add_theme_color_override("font_pressed_color", Color("CYAN"))
		upgrade_button.add_theme_color_override("font_hover_color", Color("CYAN"))
		upgrade_button.add_theme_color_override("font_disabled_color", Color("CYAN"))
		upgrade_button.add_theme_color_override("font_focus_color", Color("CYAN"))
	else:
		upgrade_button.add_theme_color_override("font_color", Color("RED"))
		upgrade_button.add_theme_color_override("font_pressed_color", Color("RED"))
		upgrade_button.add_theme_color_override("font_hover_color", Color("RED"))
		upgrade_button.add_theme_color_override("font_disabled_color", Color("RED"))
		upgrade_button.add_theme_color_override("font_focus_color", Color("RED"))


func get_color(value: float, min_value: float, max_value: float) -> Color:
	var t = (value - min_value) / (max_value - min_value)
	return Color(1.0 - t, t, 0.0,)
	
	
func _on_slider_value_changed(value):
	update_slider_info()
	current_value_int.text = str(value) + " "
	var color = get_color(value, slider.min_value, slider.max_value)
	current_value_int.self_modulate = color
	set_values_in_global()
	
func set_values_in_global():
	if name_of_the_skill == "Movement speed":
		PlayerSkills.movement_speed = slider.value
	if name_of_the_skill == "Attack speed":
		PlayerSkills.attack_speed = slider.value
	if name_of_the_skill == "Bullet speed":
		PlayerSkills.bullet_speed = slider.value
	if name_of_the_skill == "Bullet damage":
		PlayerSkills.bullet_damage = slider.value
	if name_of_the_skill == "Blood splats":
		PlayerSkills.blood_splats = slider.value
	if name_of_the_skill == "Splat size":
		PlayerSkills.splat_size = slider.value / 100
	if name_of_the_skill == "Stun power":
		PlayerSkills.stunpower = slider.value
		
	if name_of_the_skill == "Powerup attackspeed":
		PlayerSkills.powerup_attackspeed = slider.value
	if name_of_the_skill == "Powerup damage":
		PlayerSkills.powerup_damage = slider.value
	if name_of_the_skill == "Powerup wrap":
		PlayerSkills.powerup_wrap = slider.value



