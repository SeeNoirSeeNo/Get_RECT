extends Node
signal skillpoints_updated(skillpoints)


var _skillpoints = 0
var skillpoints:
	get:
		return _skillpoints
	set(value):
		_skillpoints = value
		emit_signal("skillpoints_updated")

#Stats come from Skills.gd, Player.gd fetches them
var movement_speed
var attack_speed # 100 = Attack once every seconds
var bullet_speed
var bullet_damage
var default_damage

#Stats come from Skills.gd, ObjectSpawner.gd fetches them
var	splat_size
var blood_splats
#var particle_scale_amount_max


var skill_level = {
	"Bullet damage" 	: 0,
	"Bullet speed" 		: 0,
	"Attack speed" 		: 0,
	"Movement speed" 	: 0,
	"Blood splats"		: 0,
	"Splat size" 		: 0,

}
