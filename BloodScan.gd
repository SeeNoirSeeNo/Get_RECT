extends Control
#ONREADY
@onready var player = $"../Player"

var area_size = Vector2(960, 540)
var area_top_left = -area_size / 2  # Top-left corner of the area
var area_bottom_right = area_size / 2  # Bottom-right corner of the area
var arenaEdgeLeft = area_top_left.x
var arenaEdgeRight = area_bottom_right.x
var arenaEdgeTop = area_top_left.y
var arenaEdgeBottom = area_bottom_right.y
var default_color = Color8(5, 5, 5, 255)
###BLOOD###
var blood_percentage : float
var blood_count : int

func _ready():
	self.z_index = -100

func _draw():
	var inner_color = Color8(5, 5, 5, 255)
	var border_color = Color8(255, 0, 0, 255)  # Red color
	var border_width = 2  # Width of the border
	# Draw the inner area
	draw_rect(Rect2(area_top_left, area_bottom_right - area_top_left), inner_color, true)
	# Draw the border
	draw_rect(Rect2(area_top_left, area_bottom_right - area_top_left), border_color, false, border_width)

###LOW RES WORKING###
func count_blood_pixels_low_res():
	var viewport = get_viewport().get_texture().get_image()
	var blood_pixel_count = 0
	var total_pixels = area_size.x * area_size.y
	#LOOP THROUGH ALL PIXELS
	for x in range(int(area_top_left.x), int(area_bottom_right.x)):
		for y in range(int(area_top_left.y), int(area_bottom_right.y)):
			var pixel_color = viewport.get_pixel(int(x + self.global_position.x), int(y + self.global_position.y))
			if pixel_color != default_color:
				blood_pixel_count += 1
	blood_percentage = round((blood_pixel_count / total_pixels) * 100 * 100) / 100
	blood_count = blood_pixel_count #Not needed if I adjust next line?!
	Global.pixels = blood_count
	Global.coverage = blood_percentage
