# blood_percentage.gd
extends Label

@onready var sparkle = $sparkle

var grow_speed = 1.125  # Speed of the growing effect
var base_scale = Vector2(0.25, 0.25)  # Base scale of the label

func _ready():
	Global.blood_percentage_updated.connect(self._on_blood_percentage_updated)

func _process(delta):
	# Make the label grow
	if scale.x < 0.5 and scale.y < 0.5:  # Prevent the label from growing too much
		scale += Vector2(1, 1) * grow_speed * delta

func _on_blood_percentage_updated():
	# Update the text of the label
	text = str(Global.blood_percentage)
	# Generate a random color
	var new_color = Color(randf(), randf(), randf(), 1.0)
	# Apply the color to the label
	modulate = new_color
	# Reset the scale of the label
	scale = base_scale
	# Update the properties of the sparkles
	emit_sparkles(Global.blood_percentage)
	
func emit_sparkles(percentage):
	var new_sparkle = sparkle.duplicate()
	# Increase the amount of sparkles and size of particles based on the blood percentage
	var multiplier = percentage / 100  # Adjust this value to fit the range of the blood percentage
	new_sparkle.amount += int(multiplier * 10)
	# Add the new sparkle instance to the scene
	add_child(new_sparkle)
	# Start emitting particles
	new_sparkle.emitting = true
