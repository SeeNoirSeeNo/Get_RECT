#PowerUp_Damage
extends PowerUp


var wrap_multiplier = 1

func _ready():
	ID = "PowerUp_Wrap"
	color = Color8(0,114,0)
	self_modulate = color
	add_to_group("Powerups")
	
func activate():
	print(ID, " Active")
	var player = get_node("/root/Arena/Player")
	player.add_active_powerup_color(color)
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	visible = false
	player.modify_wrap(wrap_multiplier)
	await get_tree().create_timer(duration).timeout
	print(ID, " Deactivated")
	player.remove_active_powerup_color(color)
	player.modify_wrap(-wrap_multiplier)
	queue_free()
