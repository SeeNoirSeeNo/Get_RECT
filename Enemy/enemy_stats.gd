extends Control
@onready var panel = $StatsPanel
@onready var object_spawner = $"../objectSpawner"
@onready var representations = $representations
@onready var skills_info = $StatsPanel/VBoxContainer/HBoxContainer4/SkillsInfo

@onready var stage_int = $StatsPanel/VBoxContainer/HBoxContainer/StageINT
@onready var hp_int = $StatsPanel/VBoxContainer/Core/HBoxContainer3/HPINT
@onready var speed_int = $StatsPanel/VBoxContainer/Core/HBoxContainer4/SpeedINT
@onready var behavior_int = $StatsPanel/VBoxContainer/Special/HBoxContainer4/BehaviorINT
@onready var screenshake_int = $StatsPanel/VBoxContainer/Special2/HBoxContainer3/ScreenshakeINT
@onready var knockback_int = $StatsPanel/VBoxContainer/Special/HBoxContainer3/KnockbackINT
@onready var bounty_int = $StatsPanel/VBoxContainer/Core/HBoxContainer5/BountyINT
@onready var blood_amount_int = $StatsPanel/VBoxContainer/Special/HBoxContainer5/BloodAmountINT
@onready var blood_size_int = $StatsPanel/VBoxContainer/Special2/HBoxContainer5/BloodSizeINT






func _ready():
	var index = 0
	for rep in representations.get_children():
		var area = rep.get_node("Area2D")
		area.mouse_entered.connect(_on_mouse_entered.bind(rep))
		area.mouse_exited.connect(_on_mouse_exited.bind(rep))
		rep.set_meta("index", index)  # Store the index in the metadata
		rep.visible = false  # Initially hide all representatives
		index += 1
	panel.hide()
	Global.stage_changed.connect(_on_stage_changed)


func _on_stage_changed(stage):
	for rep in representations.get_children():
		var index = rep.get_meta("index")  # Get the index from the metadata
		if index < stage:
			rep.visible = true  # Show the representative if its index is less than the current stage
			rep.modulate = object_spawner.enemy_attributes_array[index].modulate

			
func update_skills_info(enemy_attributes):
	var color_map = {
	#Colors for the Skill-Names
	"Very Fast": "00b4d8",
	"Fast": "48cae4",
	"Very Slow": "#84dcc6",
	"Slow": "#a5ffd6",
	"Very Sturdy": "#621708",
	"Sturdy": "#941b0c",
	"Shaker": "#DEF012",
	"Bullet Stopper": "#DEF012",
	"Bullet Slower": "8f2d56",
	"Bullet Attractor": "#DEF012",
	
	#Colors for the Skill-Values
	"Speed": "#00FF00", #Green
	"Slowed" : "708d81",
	"HP": "#d00000", #Red
	"Bounty" : "FFFF00", #Yellow
	"Screen-Shake" : "E76F51",
	"Bullet Stop Duration" : "#4ECDC4",
	"Force" : "#776FD3",
	"Knockback" : "F694C1"
	}
	
	var rows = []
	for skill in enemy_attributes.skill_data:
		var name = skill["name"]
		var color = color_map.get(name, "white")  # Get the color for the name, or default to white
		var colored_name = "[color=" + color + "]" + name + "[/color]"
		var attributes = ""
		for key in skill.keys():
			if key != "name":
				color = color_map.get(key, "white")  # Get the color for the key, or default to white
				attributes += "[" + "[color=" + color + "]" + key + " +" +  str(skill[key]) + "[/color]" + "] "
		var row = colored_name + ": " + attributes + "\n"
		rows.append(row)
	rows.sort()
	skills_info.text = "".join(rows)
	
func _on_mouse_entered(rep):
	if Global.scan_ongoing == false:
		panel.show()
		#var stage_index = Global.current_stage - 1
		var index = rep.get_meta("index")  # Get the index from the metadata
		var enemy_attributes = object_spawner.enemy_attributes_array[index]
		stage_int.text = "Stage " + str(index+1) + " Enemy"

		hp_int.text = str(enemy_attributes.hp)
		hp_int.add_theme_color_override("font_color", Color("#d00000"))
		
		speed_int.text = str(enemy_attributes.speed)
		speed_int.add_theme_color_override("font_color", Color("00FF00"))
		
		#behavior_int.text = str(enemy_attributes.hp)
		#behavior_int.add_theme_color_override("font_color", Color("00FF00"))
		
		screenshake_int.text = str(enemy_attributes.screen_shake)
		screenshake_int.add_theme_color_override("font_color", Color("E76F51"))
		
		knockback_int.text = str(enemy_attributes.knockback)
		knockback_int.add_theme_color_override("font_color", Color("F694C1"))
		
		bounty_int.text = str(enemy_attributes.bounty)
		bounty_int.add_theme_color_override("font_color", Color("FFFF00"))
		
		blood_amount_int.text = str(enemy_attributes.particle_amount)
		blood_size_int.text = str((enemy_attributes.particle_scale_amount_min + enemy_attributes.particle_scale_amount_max) / 2)

		skills_info.text = ""
		update_skills_info(enemy_attributes)
		get_tree().paused = true


func _on_mouse_exited(_rep):
	panel.hide()
	get_tree().paused = false

