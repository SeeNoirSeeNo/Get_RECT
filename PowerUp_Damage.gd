#PowerUp_Damage
extends PowerUp


var damage_multiplier = 10

func _ready():
	ID = "PowerUp_Damage"
	color = Color8(173,46,36)
	self_modulate = color
	add_to_group("Powerups")
	
func activate():
	print(ID, " Active")
	var player = get_node("/root/Arena/Player")
	player.add_active_powerup_color(color)
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	visible = false
	player.modify_damage(damage_multiplier)
	await get_tree().create_timer(duration).timeout
	print(ID, " Deactivated")
	player.remove_active_powerup_color(color)
	player.modify_damage(1.0 / damage_multiplier)
	queue_free()
