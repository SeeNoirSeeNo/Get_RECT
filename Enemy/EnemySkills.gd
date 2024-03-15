#EnemySkills.gd - Singleton
extends Node



var available_skills = [

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
]

func fast(attributes, _stage):
	var speed_bonus = randi_range(5, 20)
	attributes.speed += speed_bonus
	attributes.bounty += speed_bonus * 2

func very_fast(attributes, _stage):
	var speed_bonus = randi_range(21, 40)
	attributes.speed += speed_bonus
	attributes.bounty += speed_bonus * 2.5
	
func slow(attributes, _stage):
	var speed_bonus = randi_range(5, 20)
	attributes.speed -= speed_bonus
	attributes.bounty -= speed_bonus * 2.0
	
func very_slow(attributes, _stage):
	var speed_bonus = randi_range(21, 40)
	attributes.speed -= speed_bonus
	attributes.bounty -= speed_bonus * 2.5

func very_sturdy(attributes, stage):
	attributes.hp += ceil(stage / 2.0) 
	attributes.bounty += ceil(stage / 2.0) * 25

func sturdy(attributes, stage):
	attributes.hp += ceil(stage / 3.0) 
	attributes.bounty += ceil(stage / 3.0) * 25

func shaker(attributes, stage):
	attributes.screen_shake += stage * 10
	attributes.bounty += ceil(stage / 3.0) * 25

func agent(_attributes, _stage):
	pass #color BLACK so HP is hidden & tooltipp is hidden
	
func bullet_stopper(attributes, stage):
	attributes.is_bullet_stopper = true
	attributes.bullet_stopper_duration_min = 0.1 * stage
	attributes.bullet_stopper_duration_max = 0.2 * stage
	attributes.bounty += ceil(stage / 3.0) * 25

func bullet_attractor(attributes, stage):
	attributes.hp += stage 
	attributes.is_bullet_attractor = true

func bullet_slower(attributes, stage):
	attributes.is_bullet_slower = true 
	attributes.repelling_force = 0.9 ** stage
	
func desperate(_attributes, _stage):
	pass #faster when HP low
	
func confuser(_attributes, _stage):
	pass #player shoots in random direction
