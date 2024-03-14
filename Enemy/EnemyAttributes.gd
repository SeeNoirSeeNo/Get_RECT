extends Resource
class_name EnemyAttributes

#Core
var hp = 1
var speed = 50
var bounty = 10
var modulate = Color()
#Offset
var offset_chance = 0.0
var offset_range = 0
var offset_min_time = 0.0
var offset_max_time = 0.0
#Meta
var knockback = 0
var screen_shake = 0
#Sounds
var impact_sound = ["impact_1", "impact_2"]
var dying_sound = ["dying_1","dying_2","dying_3","dying_4"]
#Particles
var particle_scale_amount_min = 0
var particle_scale_amount_max = 0
var particle_amount : int = 100  # New attribute for particle amount
#Skills
var picked_skills = []
#Skills - BULLET STOPPER
var is_bullet_stopper = false
var bullet_stopper_duration_min = 0
var bullet_stopper_duration_max = 0
#Skills - ATTRACTOR
var is_bullet_attractor = false
#Skills - SLOWER
var is_bullet_slower = false
var repelling_force = 0.0
