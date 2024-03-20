extends Sprite2D

@onready var bloodScan = get_parent().get_node("BloodScan")
@onready var debris = preload("res://hit_debris.tscn")
@onready var damage_label = $DamageLabel
var active_powerup_colors = []  # New variable
var color_change_interval = 0.15  # Change color every 0.5 seconds
var color_ID = 0

var velocity = Vector2(1,0)
var speed = 250
var original_speed = speed
var damage = 0 #Changed in Player Script
var look_once = true
var is_stopped = false
var bullet_wrap = 0
var bullet_wrap_decay = 0
#var bullet_sounds = ["shoot_4", "shoot_5", "shoot_6",]
var bullet_sounds = ["shoot_1", "shoot_2", "shoot_3", "shoot_4", "shoot_5", "shoot_6"]
var attracting_enemy = null

var launch_velocity = Vector2()
var gravitational_pull_strength = randi_range(100,300)
var slowing_enemies = []

func _ready():
	var timer = Timer.new()
	timer.wait_time = color_change_interval
	timer.autostart = true
	timer.timeout.connect(self._on_timer_timeout)
	add_child(timer)
	Global.play_sound(bullet_sounds.pick_random())
	damage_label.text = str(damage)
	var direction_to_mouse = (get_global_mouse_position() - global_position).normalized()
	rotation = direction_to_mouse.angle()
	launch_velocity = velocity.rotated(rotation)
	velocity = launch_velocity

func set_active_powerup_colors(colors):
	active_powerup_colors = colors

func _on_timer_timeout():
	damage_label.text = str(damage)
	if active_powerup_colors.size() > 0:
		modulate = active_powerup_colors[color_ID]
		color_ID += 1
		if color_ID >= active_powerup_colors.size():
			color_ID = 0

func _process(delta):
	attracting_enemy = find_nearest_attracting_enemy()
	if attracting_enemy != null:
		var direction_to_enemy = (attracting_enemy.global_position - global_position).normalized()
		var distance_to_enemy = global_position.distance_to(attracting_enemy.global_position)
		var pull_strength = gravitational_pull_strength / max(distance_to_enemy, 1)  # Avoid division by zero
		velocity += direction_to_enemy * pull_strength * delta
	velocity = velocity.normalized()  # Normalize velocity
	global_position += velocity * speed * delta
	
	if global_position.x < (bloodScan.arenaEdgeLeft + Global.arena_offset_left) or global_position.x > (bloodScan.arenaEdgeRight + Global.arena_offset_right) or global_position.y < (bloodScan.arenaEdgeTop + Global.arena_offset_top) or global_position.y > (bloodScan.arenaEdgeBottom +  Global.arena_offset_bottom):
		var old_position = position
		if bullet_wrap >= randf():
			position.x = wrapf(position.x, bloodScan.arenaEdgeLeft + Global.arena_offset_left, bloodScan.arenaEdgeRight + Global.arena_offset_right)
			position.y = wrapf(position.y, bloodScan.arenaEdgeTop + Global.arena_offset_top, bloodScan.arenaEdgeBottom + Global.arena_offset_bottom)
			if old_position != position:
				bullet_wrap *= bullet_wrap_decay
		else:
			var _debris_instance = Global.instance_node(debris, global_position, Global.node_creation_parent)
			if active_powerup_colors.size() > 0:
				_debris_instance.modulate = active_powerup_colors[color_ID]
			queue_free()

func find_nearest_attracting_enemy():
	var nearest_enemy = null
	var nearest_distance = INF

	for enemy in get_tree().get_nodes_in_group("in_arena"):
		if enemy.is_bullet_attractor:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_enemy = enemy
	return nearest_enemy


func stop_bullet(stop_duration):
	speed = 0
	await get_tree().create_timer(stop_duration).timeout
	speed = original_speed
	
func slow_bullet(enemy, force):
	slowing_enemies.append([enemy, force])  # Add the enemy and its slow force to the list
	update_speed()

func remove_slow(enemy):
	#slowing_enemies = [e for e in slowing_enemies if e[0] != enemy]
	var new_slowing_enemies = []
	for e in slowing_enemies:
		if e[0] != enemy:
			new_slowing_enemies.append(e)
	slowing_enemies = new_slowing_enemies
	update_speed()
	
func update_speed():
	speed = original_speed
	for e in slowing_enemies:
		speed *= e[1]  # Apply the slow force of each enemy

