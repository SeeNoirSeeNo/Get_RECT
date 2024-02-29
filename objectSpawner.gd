extends Node2D

@export var enemies: Array[PackedScene]
@export var power_ups: Array[PackedScene]

@onready var bloodScan = $"../BloodScan"
@onready var enemySpawnTimer = $Enemy_spawn_timer


func _on_enemy_spawn_timer_timeout():
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
			
			
	var enemy_number = round(randf_range(0, enemies.size() -1))
	Global.instance_node(enemies[enemy_number], enemy_position, self)
	enemySpawnTimer.wait_time *= Global.spawn_multiplicator


func _on_power_up_spawn_timer_timeout():
	Global.play_sound("powerup_spawn")
	var power_up_number = round(randf_range(0, power_ups.size() -1))
	Global.instance_node(power_ups[power_up_number], Vector2(randf_range(170, 1100), randf_range(95, 620)), self)
