extends Control
var area_size = Vector2(960, 540)
var area_top_left = -area_size / 2  # Top-left corner of the area
var area_bottom_right = area_size / 2  # Bottom-right corner of the area
var arenaEdgeLeft = area_top_left.x
var arenaEdgeRight = area_bottom_right.x
var arenaEdgeTop = area_top_left.y
var arenaEdgeBottom = area_bottom_right.y
var default_color = Color8(35, 35, 35, 255)
###LOWRES THUMBNAIL FACTOR
var scale_factor = 0.5
###BLOOD###
var blood_percentage_low : float
var blood_percentage_full : float
var blood_count_low : int
var blood_count_full : int
###CONTROL###
var active = true

func _ready():
	self.z_index = -100

func _on_blood_scan_timer_timeout():
	count_blood_pixels_low_res()
	
func _draw():
	var inner_color = Color8(35, 35, 35, 255)
	var border_color = Color8(255, 0, 0, 255)  # Red color
	var border_width = 2  # Width of the border
	# Draw the inner area
	draw_rect(Rect2(area_top_left, area_bottom_right - area_top_left), inner_color, true)
	# Draw the border
	draw_rect(Rect2(area_top_left, area_bottom_right - area_top_left), border_color, false, border_width)


### FULL RES WORKING ### --> USE AT END OF GAME <--
#func count_blood_pixels_full_res():
#	var viewport = get_viewport().get_texture().get_image()
#	var blood_pixel_count = 0
#	var total_pixels = area_size.x * area_size.y
#	#LOOP THROUGH ALL PIXELS
#	for x in range(int(area_top_left.x), int(area_bottom_right.x)):
#		for y in range(int(area_top_left.y), int(area_bottom_right.y)):
#			var pixel_color = viewport.get_pixel(int(x + self.global_position.x), int(y + self.global_position.y))
#			if pixel_color != default_color:
#				blood_pixel_count += 1
#
#	blood_percentage_full = round((blood_pixel_count / total_pixels) * 100 * 100) / 100
#	blood_count_full = blood_pixel_count
#	print("FULLRES %" + str(blood_percentage_full))
#	print("FULLRES COUNT" + str(blood_count_full))

###LOW RES WORKING###
func count_blood_pixels_low_res():
	if active == true:
		var viewport = get_viewport().get_texture().get_image()
		viewport.resize(int(viewport.get_width() * scale_factor), int(viewport.get_height() * scale_factor))
		var blood_pixel_count = 0
		var total_pixels = area_size.x * area_size.y * scale_factor * scale_factor
		#LOOP THROUGH ALL PIXELS
		for x in range(int(area_top_left.x * scale_factor), int(area_bottom_right.x * scale_factor)):
			for y in range(int(area_top_left.y * scale_factor), int(area_bottom_right.y * scale_factor)):
				var pixel_color = viewport.get_pixel(int(x + self.global_position.x * scale_factor), int(y + self.global_position.y * scale_factor))
				if pixel_color != default_color:
					blood_pixel_count += 1

		blood_percentage_low = round((blood_pixel_count / total_pixels) * 100 * 100) / 100
		blood_count_low = blood_pixel_count * (1/scale_factor) * (1/scale_factor)
		Global.pixels = blood_count_low
		Global.coverage = blood_percentage_low
