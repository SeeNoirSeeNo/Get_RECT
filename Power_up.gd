extends Sprite2D

@export var power_up_name : String
@export var player_variable_modify : String
@export var player_variable_set : float
@export var player_variable_modify_2 : String
@export var player_variable_set_2 : Color
@export var power_up_duration : float

var power_up_sound = ["powerUpPickup_1",]

func _on_hitbox_area_entered(area):
	if area.is_in_group("Player") and area.get_parent().power_up_active == false:
		Global.play_sound(power_up_sound.pick_random())
		print("picked up!")
		area.get_parent().set(player_variable_modify, player_variable_set)
		area.get_parent().set(player_variable_modify_2, player_variable_set_2)
		area.get_parent().get_node("Power_up_cooldown").wait_time = power_up_duration
		area.get_parent().get_node("Power_up_cooldown").start()
		area.get_parent().power_up_reset.append(name)
		area.get_parent().power_up_active = true
		queue_free()
