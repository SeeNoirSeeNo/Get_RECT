extends Sprite2D
### MOVEMENT ###
@export var offset_chance : float = 0.31  # Chance to use offset, between 0 and 1
@export var offset_range : int = 50
@export var offset_min_time : float = 0.01  # Minimum time to update target position
@export var offset_max_time : float = 2.00  # Maximum time to update target position

@export var speed : int = 75
@export var hp : int = 3
@export var knockback : int = 600
@export var points : int = 10
@export var screen_shake : int = 80
@export var death_sound : String = " "
### DROPCHANCE 0% ###
@export var drop_chance : int = 0

@onready var current_color = modulate
#this will be hard to type on mobile so sorry, but you can have a float representing a hue, and an array[color] of the enemy colors, and with a for loop add randf_range(0.05, 0.2) to that float, and set the h property to the float



var impact_sound_array = ["impact_1", "impact_2"]
var target_position = Vector2()  # The position the enemy is moving towards
var use_offset : bool
var offset_timer : Timer
var velocity = Vector2()
var stun = false
var blood_particles = preload("res://blood_particles.tscn")
var debris = preload("res://hit_debris.tscn")
var droppable_items = preload("res://useable_powerup_wrap.tscn")

func _ready():
	offset_timer = Timer.new()  # Create a new timer
	add_child(offset_timer)  # Add the timer as a child of this node
	offset_timer.timeout.connect(_on_timer_timeout)  # Connect the timer's timeout signal to the _on_timer_timeout function
	use_offset = randf() < offset_chance # Decide whether this enemy uses offset
	if use_offset:
		_on_timer_timeout()  # Call the function to set an initial target position
		offset_timer.start(randf_range(offset_min_time, offset_max_time))  # Start the timer with a random time
	if Global.chaosMode == true:
		modulate = Global.pickRandomColor()
		current_color = modulate
		#current_color = Global.pickRandomColor()
		
func _process(_delta):
	if hp <= 0:
		if Global.camera != null:
			Global.camera.screen_shake(screen_shake, 0.2)

		Global.killBounty += points
		if randi_range(1, 100) <= drop_chance:
			if Global.node_creation_parent != null:
				var _item_drop = Global.instance_node(droppable_items, global_position, Global.node_creation_parent)			
		#Global.play_sound(death_sound)
		
		if Global.node_creation_parent != null:
			var blood_particles_instance = Global.instance_node(blood_particles, global_position, Global.node_creation_parent.get_node("blood"))
			blood_particles_instance.rotation = velocity.angle()
			blood_particles_instance.color = current_color
		queue_free()


func basic_movement_towards_player(delta):
	if Global.player != null and stun == false:
		if not use_offset:
			target_position = Global.player.global_position  # Update the target position each frame if not using offset
		velocity = global_position.direction_to(target_position)  # Move towards the target position
		global_position += velocity * speed * delta
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
		global_position += velocity * delta


func _on_hitbox_area_entered(area):
	if area.is_in_group("Enemy_damager") and stun == false:
		modulate = Color.WHITE
		velocity = (global_position - Global.player.global_position).normalized() * knockback  # Knockback direction is away from the player
		Global.play_sound(impact_sound_array.pick_random())
		hp -= area.get_parent().damage
		stun = true
		$Stun_timer.start()
		var _debris_instance = Global.instance_node(debris, global_position, Global.node_creation_parent)
		_debris_instance.modulate = area.get_parent().modulate
		area.get_parent().queue_free()
		
func _on_stun_timer_timeout():
	modulate = current_color
	stun = false

func _on_timer_timeout():
	if Global.player != null and use_offset:
		var offset = Vector2(randf_range(-offset_range, offset_range), randf_range(-offset_range, offset_range))  # Generate a random offset if use_offset is true
		target_position = Global.player.global_position + offset  # Update the target position
	if use_offset:
		offset_timer.start(randf_range(offset_min_time, offset_max_time))  # Restart the timer with a new random time
