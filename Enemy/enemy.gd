extends Sprite2D
#SIGNALS
signal enemy_died
#PRELOAD SCENES
var blood_particles = preload("res://blood_particles.tscn")
var debris = preload("res://hit_debris.tscn")
#COLOR
@onready var current_color = modulate
#MOVEMENT-RELATED
#OFFSET
var offset_chance : float = 0.00  # Chance to use offset, between 0 and 1
var use_offset : bool
var target_position = Vector2()  # The position the enemy is moving towards
var offset_range : int = 0
#OFFSET-TIMER
var offset_timer : Timer
var offset_min_time : float = 0.00  # Minimum time to update target position
var offset_max_time : float = 1.00  # Maximum time to update target position
#GENERAL STATS
var speed : int = 50
var velocity = Vector2()
var hp : int = 1
@onready var hp_label = $hp_label
var bounty : int = 0
#VARIOUS STATS
var stun = false
var knockback : int = 1
var screen_shake : int = 1
#SOUNDS
var death_sound = []
var impact_sound = []
#Particles
var particle_scale_amount_min : int = 0
var particle_scale_amount_max : int = 0
var particle_amount : int = 0


#METHODS
func _ready():
	initialize_offset()
	hp_label.text = str(hp)
	add_to_group("enemies")
	
func _process(delta):
	basic_movement_towards_player(delta)
	if hp <= 0:
		die()

### MOVEMENT ###
func initialize_offset():
	use_offset = randf() < offset_chance # Decide whether this enemy uses offset
	if use_offset:
		offset_timer = Timer.new()  # Create a new timer
		add_child(offset_timer)  # Add the timer as a child of this node
		offset_timer.timeout.connect(_on_offset_timer_timeout)  # Connect the timer's timeout signal to the _on_timer_timeout function
		_on_offset_timer_timeout()  # Call the function to set an initial target position
		offset_timer.start(randf_range(offset_min_time, offset_max_time))  # Start the timer with a random time


func basic_movement_towards_player(delta):
	if Global.player != null and stun == false:
		if speed < 20:
			speed = 20
		if not use_offset:
			target_position = Global.player.global_position  # Update the target position each frame if not using offset
		velocity = global_position.direction_to(target_position)  # Move towards the target position
		global_position += velocity * speed * delta
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
		global_position += velocity * delta

func set_attributes(attributes: EnemyAttributes):
	hp = attributes.hp
	bounty = attributes.bounty
	offset_chance = attributes.offset_chance
	offset_range = attributes.offset_range
	offset_min_time = attributes.offset_min_time
	offset_max_time = attributes.offset_max_time
	speed = attributes.speed
	knockback = attributes.knockback
	screen_shake = attributes.screen_shake
	impact_sound = attributes.impact_sound
	death_sound = attributes.dying_sound
	modulate = attributes.modulate
	particle_scale_amount_min = attributes.particle_scale_amount_min
	particle_scale_amount_max = attributes.particle_scale_amount_max
	particle_amount = attributes.particle_amount  # Set the particle amount

### DIE ###
func die():
	if Global.camera != null:
		Global.camera.screen_shake(screen_shake, 0.2)
	Global.killBounty += bounty
	if Global.node_creation_parent != null:
		var blood_particles_instance = Global.instance_node(blood_particles, global_position, Global.node_creation_parent.get_node("blood"))
		blood_particles_instance.rotation = velocity.angle()
		blood_particles_instance.color = current_color
		blood_particles_instance.scale_amount_min = particle_scale_amount_min  # Set the particle size
		blood_particles_instance.scale_amount_max = particle_scale_amount_max # Set the particle size
		blood_particles_instance.amount = particle_amount  # Set the particle amount
		emit_signal("enemy_died")
	#Global.play_sound(death_sound)
	queue_free()

### COLLISION ###
func _on_hitbox_area_entered(area):
	if area.is_in_group("Enemy_damager") and stun == false:
		modulate = Color.WHITE
		velocity = (global_position - Global.player.global_position).normalized() * knockback  # Knockback direction is away from the player
		Global.play_sound(impact_sound)
		hp -= area.get_parent().damage
		hp_label.text = str(hp)
		stun = true
		$Stun_timer.start()
		var _debris_instance = Global.instance_node(debris, global_position, Global.node_creation_parent)
		_debris_instance.modulate = area.get_parent().modulate
		area.get_parent().queue_free()


### TIMERS ###
func _on_stun_timer_timeout():
	modulate = current_color
	stun = false

func _on_offset_timer_timeout():
	if Global.player != null and use_offset:
		var offset = Vector2(randf_range(-offset_range, offset_range), randf_range(-offset_range, offset_range))  # Generate a random offset if use_offset is true
		target_position = Global.player.global_position + offset  # Update the target position
	if use_offset:
		offset_timer.start(randf_range(offset_min_time, offset_max_time))  # Restart the timer with a new random time
