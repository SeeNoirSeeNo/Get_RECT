extends Resource
class_name EnemyAttributes

#Core
var hp = 1
var speed = 0
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
