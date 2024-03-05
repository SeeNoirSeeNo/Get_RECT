#PowerUp.gd
extends Sprite2D
class_name PowerUp

var ID = "PowerUp_ID"
var color = Color.WHITE
var base_color = color
var duration = 5.0

func _on_hitbox_area_entered(area):
	if area.is_in_group("Player"):
		activate()

		
func activate():
	pass
