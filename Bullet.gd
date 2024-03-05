extends Sprite2D

@onready var bloodScan = get_parent().get_node("BloodScan")
@onready var debris = preload("res://hit_debris.tscn")

var active_powerup_colors = []  # New variable
var color_change_interval = 0.15  # Change color every 0.5 seconds
var color_ID = 0

var velocity = Vector2(1,0)
var speed = 250
var damage #Changed in Player Script
var look_once = true
var bullet_wrap = 0
var bullet_wrap_decay = 0
var bullet_sounds = ["shoot_4", "shoot_5", "shoot_6",]
#var bullet_sounds = ["shoot_1", "shoot_2", "shoot_3",]
var heavy_bullet_sounds = ["shoot_4", "shoot_5", "shoot_6"]
var type = "normal"

func _ready():
	var timer = Timer.new()
	timer.wait_time = color_change_interval
	timer.autostart = true
	timer.timeout.connect(self._on_timer_timeout)
	add_child(timer)


func set_active_powerup_colors(colors):
	active_powerup_colors = colors


func _on_timer_timeout():
	if active_powerup_colors.size() > 0:
		modulate = active_powerup_colors[color_ID]
		color_ID += 1
		if color_ID >= active_powerup_colors.size():
			color_ID = 0

func _process(delta):
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false

	if global_position.x < (bloodScan.arenaEdgeLeft + Global.arena_offset_left) or global_position.x > (bloodScan.arenaEdgeRight + Global.arena_offset_right) or global_position.y < (bloodScan.arenaEdgeTop + Global.arena_offset_top) or global_position.y > (bloodScan.arenaEdgeBottom +  Global.arena_offset_bottom):
		var old_position = position
		print(bullet_wrap)
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

	global_position += velocity.rotated(rotation) * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
