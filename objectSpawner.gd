extends Node2D
#SIGNALS
signal enemy_spawned(new_enemy)
#PRELOADS
var EnemyAttributes = preload("res://Enemy/EnemyAttributes.gd")
var EnemyScene = preload("res://Enemy/enemy.tscn")
var power_ups = [preload("res://PowerUp_Damage.tscn"), preload("res://PowerUp_ShootingSpeed.tscn"), preload("res://PowerUp_Wrap.tscn")]
#ONREADYS
@onready var enemySpawnTimer = $Enemy_spawn_timer
@onready var powerUpSpawnTimer = $Power_up_spawn_timer
#VARS
var enemy_attributes_array = []

func _ready():
	#CONNECT SIGNALS
	Global.stage_changed.connect(self._on_stage_changed)
	
func _on_stage_changed(stage):
	create_enemy_type(stage)

func stop_spawning():
	enemySpawnTimer.stop()
	powerUpSpawnTimer.stop()
func start_spawning():
	enemySpawnTimer.start()
	powerUpSpawnTimer.start()

func create_enemy_type(stage):
	var attributes = EnemyAttributes.new()  # Create a new EnemyAttributes resource
	initilize_attributes(attributes,stage)
	pick_random_skills(attributes, stage)
	enemy_attributes_array.append(attributes)

func pick_random_skills(attributes, stage):
	var skill_points = stage
	while skill_points > 0:
		var random_skill = EnemySkills.available_skills[randi() % EnemySkills.available_skills.size()]
		EnemySkills.call(random_skill["name"], attributes, stage)
		attributes.picked_skills.append(random_skill)
		print("Stage:", stage)
		print(random_skill)
		skill_points -= 1

func initilize_attributes(attributes,stage):
	attributes.hp = stage
	attributes.bounty = 10 * stage
	attributes.speed += 5 * stage
	attributes.impact_sound = attributes.impact_sound.pick_random()
	attributes.dying_sound = attributes.dying_sound.pick_random()
	attributes.modulate = Global.pickRandomColor()  # Randomize the color
	attributes.offset_chance = randf()  # Randomize the offset_chance between 0 and 1
	attributes.offset_range = randi() % 100  # Randomize the offset_range between 0 and 100
	attributes.offset_min_time = randf() * 2  # Randomize the offset_min_time between 0 and 2
	attributes.offset_max_time = randf() * 5 + 2  # Randomize the offset_max_time between 2 and 7
	attributes.knockback = randi() % 10 + 1  # Randomize the knockback between 1 and 10
	attributes.screen_shake = randi() % 5 + 1  # Randomize the screen_shake between 1 and 5
	attributes.particle_scale_amount_min = 0
	attributes.particle_scale_amount_max = 0
	attributes.particle_amount = 1

func _on_enemy_spawn_timer_timeout():
	#If CHAOSMODE is on, randomize EACH enemy
	if Global.chaosMode:
		create_enemy_type(Global.current_stage)
	#If CHAOSMODE is off, create a new enemyTYPE:
	var enemy = EnemyScene.instantiate()
	var attributes = enemy_attributes_array.pick_random()
	enemy.set_attributes(attributes)
	find_enemy_spawn_position(enemy)
	get_tree().root.add_child(enemy)
	emit_signal("enemy_spawned", enemy)
	var difficulty_factor = 1 + (Global.difficulty_setting) * 0.1
	var new_wait_time = 1 / (log(Global.current_stage + 2) * difficulty_factor)
	enemySpawnTimer.wait_time = new_wait_time

func _on_power_up_spawn_timer_timeout():
	Global.play_sound("powerup_spawn")
	var power_up_number = round(randf_range(0, power_ups.size() -1))
	Global.instance_node(power_ups[power_up_number], Vector2(randf_range(170, 1100), randf_range(95, 620)), self)
	
	
func find_enemy_spawn_position(enemy):
	var enemy_position = Vector2()
	var side = randi() % 4
	match side:
		0:  # Top
			enemy_position.x = randf_range(0, 1280)  # Screen width
			enemy_position.y = randf_range(-300, 95 - 50)
		1:  # Bottom
			enemy_position.x = randf_range(0, 1280)  # Screen width
			enemy_position.y = randf_range(620 + 50, 620 + 300)
		2:  # Left
			enemy_position.x = randf_range(-300, 170 - 50)
			enemy_position.y = randf_range(0, 720)  # Screen height
		3:  # Right
			enemy_position.x = randf_range(1100 + 50, 1100 + 300)
			enemy_position.y = randf_range(0, 720)  # Screen height
	enemy.global_position = enemy_position


