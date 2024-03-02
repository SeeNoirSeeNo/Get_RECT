extends Sprite2D

@onready var bloodScan = get_parent().get_node("BloodScan")

var velocity = Vector2(1,0)
var speed = 250
var damage #Changed in Player Script
var look_once = true
var bullet_wrap = 0
var bullet_sounds = ["shoot_4", "shoot_5", "shoot_6",]
#var bullet_sounds = ["shoot_1", "shoot_2", "shoot_3",]
var heavy_bullet_sounds = ["shoot_4", "shoot_5", "shoot_6"]
var type = "normal"

func _init():
	pass
	if bullet_wrap == 1:
		Global.play_sound(heavy_bullet_sounds.pick_random())
		print("heavy")
	else:
		Global.play_sound(bullet_sounds.pick_random())
		print("normal")


func _process(delta):
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	if bullet_wrap == 1:
		position.x = wrapf(position.x, bloodScan.arenaEdgeLeft + Global.arena_offset_left, bloodScan.arenaEdgeRight + Global.arena_offset_right)
		position.y = wrapf(position.y, bloodScan.arenaEdgeTop + Global.arena_offset_top, bloodScan.arenaEdgeBottom + Global.arena_offset_bottom)

	if global_position.x < (bloodScan.arenaEdgeLeft + Global.arena_offset_left) or global_position.x > (bloodScan.arenaEdgeRight + Global.arena_offset_right):
		queue_free()
	if global_position.y < (bloodScan.arenaEdgeTop + Global.arena_offset_top) or global_position.y > (bloodScan.arenaEdgeBottom +  Global.arena_offset_bottom):
		queue_free()
	
	global_position += velocity.rotated(rotation) * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
