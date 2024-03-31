#EnemySkills.gd - Singleton
extends Node

var available_skills = [

###///Cost, Min_Stage & Conflicts not implemented yet ///###
	{"name" 		: 	"very_fast",
	"cost" 			: 	0,
	"min_stage"		:	3,
	"conflicts" 	:	["fast", "slow", "very_slow"]
	},

	{"name" 		: 	"fast",
	"cost" 			: 	0,
	"min_stage"		:	0,
	"conflicts" 	:	["very_fast", "slow", "very_slow"]
	},

	{"name" 		: 	"very_slow",
	"cost" 			: 	0,
	"min_stage"		:	5,
	"conflicts" 	:	["very_fast", "fast", "slow"]
	},

	{"name" 		: 	"slow",
	"cost" 			: 	0,
	"min_stage"		:	5,
	"conflicts" 	:	["very_fast", "fast", "very_slow"]
	},

	{"name" 		: 	"sturdy",
	"cost" 			: 	0,
	"min_stage"		:	0,
	"conflicts" 	:	[]
	},

	{"name" 		: 	"very_sturdy",
	"cost" 			: 	0,
	"min_stage"		:	0,
	"conflicts" 	:	[]
	},

	{"name" 		: 	"shaker",
	"cost" 			: 	0,
	"min_stage"		:	0,
	"conflicts" 	:	[]
	},

	{"name" 		: 	"bullet_stopper",
	"cost" 			: 	0,
	"min_stage"		:	0,
	"conflicts" 	:	[]
	},

	{"name" 		: 	"bullet_attractor",
	"cost" 			: 	0,
	"min_stage"		:	0,
	"conflicts" 	:	[]
	},

	{"name" 		: 	"bullet_slower",
	"cost" 			: 	0,
	"min_stage"		:	0,
	"conflicts" 	:	[]
	},

	{"name" 		: 	"stun_resistance",
	"cost" 			: 	0,
	"min_stage"		:	0,
	"conflicts" 	:	[]
	},
]

func stun_resistance(attributes, stage):
	var stun_resistance = randi_range(10, 33)
	var bounty_bonus = stun_resistance + (stage * 17)
	attributes.stun_resistance += stun_resistance
	attributes.bounty += bounty_bonus
	
	
	var data = {
		"name" : "Stun resistance",
		"Stun resistance" : stun_resistance,
		"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)

func fast(attributes, _stage):
	var speed_bonus = randi_range(5, 20)
	var bounty_bonus = speed_bonus * randf_range(2, 4)
	attributes.speed += speed_bonus
	attributes.bounty += bounty_bonus
	
	
	var data = {
		"name" : "Fast",
		"Speed" : speed_bonus,
		"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)
	
func very_fast(attributes, _stage):
	var speed_bonus = randi_range(21, 40)
	var bounty_bonus = speed_bonus * randf_range(2, 4)
	attributes.speed += speed_bonus
	attributes.bounty += bounty_bonus
	var data = {
		"name" : "Very Fast",
		"Speed" : speed_bonus,
		"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)

func slow(attributes, _stage):
	var speed_bonus = randi_range(5, 20)
	var bounty_bonus = speed_bonus * 0
	attributes.speed -= speed_bonus
	attributes.bounty -= bounty_bonus
	var data = {
		"name" : "Slow",
		"Slowed" : speed_bonus,
		"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)

func very_slow(attributes, _stage):
	var speed_bonus = randi_range(21, 40)
	var bounty_bonus = speed_bonus * 0
	attributes.speed -= speed_bonus
	attributes.bounty -= bounty_bonus
	var data = {
		"name" : "Very Slow",
		"Slowed" : speed_bonus,
		"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)
	
func very_sturdy(attributes, stage):
	var hp_bonus = ceil(stage / 2.0)
	var bounty_bonus = ceil(stage / 2.0) * randi_range(20, 40)
	attributes.hp += hp_bonus
	attributes.bounty += bounty_bonus
	var data = {
		"name" : "Very Sturdy",
		"HP" : hp_bonus,
		"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)
	
func sturdy(attributes, stage):
	var hp_bonus = ceil(stage / 3.0)
	var bounty_bonus = ceil(stage / 3.0) * randi_range(20, 40)
	attributes.hp += hp_bonus
	attributes.bounty += bounty_bonus
	var data = {
		"name" : "Sturdy",
		"HP" : hp_bonus,
		"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)

func shaker(attributes, stage):
	var screen_shake_bonus = stage * 10
	var bounty_bonus = ceil(stage / 3.0)  * randi_range(15, 25)
	attributes.screen_shake += screen_shake_bonus
	attributes.bounty += bounty_bonus
	var data = {
		"name" : "Shaker",
		"Screen-Shake" : screen_shake_bonus,
		"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)


	
func bullet_stopper(attributes, stage):
	
	attributes.is_bullet_stopper = true
	
	var bullet_stopper_duration_min = 0.1 * stage
	var bullet_stopper_duration_max = 0.2 * stage
	var bounty_bonus = ceil(stage / 3.0)  * randi_range(25, 50)
	
	attributes.bullet_stopper_duration_min += bullet_stopper_duration_min
	attributes.bullet_stopper_duration_max += bullet_stopper_duration_max
	attributes.bounty += bounty_bonus
	
	var data = {
		"name" : "Bullet Stopper",
		"Bullet Stop Duration" : bullet_stopper_duration_max,
		"Bounty" : bounty_bonus,
	}
	
	add_skill_to_attributes(attributes, data)

func bullet_attractor(attributes, stage):
	attributes.is_bullet_attractor = true
	var hp_bonus = stage
	var bounty_bonus = ceil(stage / 3.0)  * randi_range(25, 45)
	attributes.hp += hp_bonus 
	attributes.bounty += bounty_bonus
	var data = {
	"name" : "Bullet Attractor",
	"HP" : hp_bonus,
	"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)
	
func bullet_slower(attributes, stage):
	attributes.is_bullet_slower = true
	var repelling_force = 0.9 ** stage
	var bounty_bonus = ceil(stage / 3.0)  * randi_range(25, 45)
	attributes.repelling_force = repelling_force
	attributes.bounty += bounty_bonus
	var data = {
	"name" : "Bullet Slower",
	"Force" : repelling_force,
	"Bounty" : bounty_bonus,
	}
	add_skill_to_attributes(attributes, data)
	
func desperate(_attributes, _stage):
	pass #faster when HP low

func confuser(_attributes, _stage):
	pass #player shoots in random direction

func agent(_attributes, _stage):
	pass #color BLACK so HP is hidden & tooltipp is hidden
	
func add_skill_to_attributes(attributes, data):
	attributes.skill_data.append(data)
