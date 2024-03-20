extends Control
@onready var animation_player = $AnimationPlayer
@onready var label = $Label


func _ready():
	#pass
	animation_player.play("Float")
	selfdestruct()

func update_label(bounty, color):
		label.add_theme_color_override("font_color", color)
		label.text = str(bounty)

func selfdestruct():
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta):
	global_position.y -= 50 * delta
