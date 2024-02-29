extends Sprite2D

@export var duration : int
#Setting The Color
#@export var player_variable_modify_2 : String
#@export var player_variable_set_2 : Color

func _on_hitbox_area_entered(area):
	if area.is_in_group("Player"):
		Global.play_sound("Powerup_pickup")
		area.get_parent().useable_powerup_wrap = true
		#Setting The Color
		#area.get_parent().set(player_variable_modify_2, player_variable_set_2)
