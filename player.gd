extends Sprite2D

#Signals
signal player_died

@onready var bullet = preload("res://bullet.tscn")
@onready var blood_particles = preload("res://blood_particles_player.tscn")
@onready var arena = $".."
@onready var camera = $"../Camera2D"
@onready var bloodScan = $"../BloodScan"

var speed = 150
var velocity = Vector2()
var current_color = modulate
var reload_speed = 0.1
var default_reload_speed = reload_speed
var power_up_reset = []
var damage = 1
var default_damage = 1
var can_shoot = true
var is_dead = false
var sound_array = ["shoot_1", "shoot_2", "shoot_3"]
var bullet_wrap = 0
var default_wrap = bullet_wrap
var bullet_color = Color(1, 1, 1, 1)
var default_bullet_color = bullet_color
var power_up_active = false
var useable_powerup_wrap = false
var invicible = false

func _ready():
	Global.player = self
	self.global_position = get_viewport().size / 2


func _exit_tree():
	Global.player = null

func _process(delta):
	velocity.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	velocity = velocity.normalized()

	var player_half_width = texture.get_width() / 2
	var player_half_height = texture.get_height() / 2
	

	global_position.x = clamp(global_position.x, (bloodScan.arenaEdgeLeft + Global.arena_offset_left) + player_half_width, (bloodScan.arenaEdgeRight + Global.arena_offset_right) - player_half_width)
	global_position.y = clamp(global_position.y, (bloodScan.arenaEdgeTop + Global.arena_offset_top) + player_half_height, (bloodScan.arenaEdgeBottom + Global.arena_offset_bottom) - player_half_height)
	
	if is_dead == false:
		global_position += speed * velocity * delta
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false:
		var bullet_instance = Global.instance_node(bullet,global_position,Global.node_creation_parent)
		bullet_instance.damage = damage
		if bullet_wrap == 1:
			bullet_instance.bullet_wrap = 1
		Global.play_sound(sound_array.pick_random())
		bullet_instance.modulate = bullet_color
		$Reload_speed.start()
		can_shoot = false


func _on_reload_speed_timeout():
	can_shoot = true
	$Reload_speed.wait_time = reload_speed


func _on_hitbox_area_entered(area):
	if invicible == false:
		if area.is_in_group("Enemy"):
			if is_dead == false and Global.node_creation_parent != null and Global.sound_controller != null:
				Global.play_sound("player_died", -5)
				var blood_particles_instance = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
				blood_particles_instance.rotation = -velocity.angle()
				blood_particles_instance.color = current_color
				is_dead = true
				visible = false
				await(get_tree().create_timer(2.5).timeout)
				emit_signal("player_died")



func _on_power_up_cooldown_timeout():
	if power_up_reset.find("Power_up_reload") != null:
		reload_speed = default_reload_speed
		power_up_reset.erase("Power_up_reload")
		
	if power_up_reset.find("Power_up_damage") != null:
		damage = default_damage
		
		power_up_reset.erase("Power_up_damage")
		
	if power_up_reset.find("Power_up_wrap") != null:
		bullet_wrap = default_wrap
		power_up_reset.erase("Power_up_wrap")
		
	bullet_color = default_bullet_color
	power_up_active = false

