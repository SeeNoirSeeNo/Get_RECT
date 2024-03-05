extends CPUParticles2D


func _ready():
	await get_tree().create_timer(0.2).timeout
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
