#PowerUp_Damage
extends PowerUp


var attackSpeed_multiplier = 3.0

func _ready():
	ID = "PowerUp_AttackSpeed"
	color = Color8(240,251,27)
	self_modulate = color
	
func activate():
	print(ID, " Active")
	var player = get_node("/root/Arena/Player")
	player.add_active_powerup_color(color)
	player.modify_attackSpeed(attackSpeed_multiplier)
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	visible = false
	await get_tree().create_timer(duration).timeout
	print(ID, " Deactivated")
	player.remove_active_powerup_color(color)
	player.modify_attackSpeed(1.0 / attackSpeed_multiplier)
	queue_free()
