extends Control

# Appearance
var button_radius := 40

# State
var shoot_center := Vector2.ZERO
var boost_center := Vector2(3 * button_radius, 0)
var touch_pos := Vector2.ZERO
var shoot_pressed := false
var boost_pressed := false

func _ready():
	# Only enable joystick on touchscreen devices
	if DisplayServer.is_touchscreen_available() and (OS.has_feature("web_ios") or OS.has_feature("web_android")):
		visible = true
		set_process_input(true)
	else:
		visible = false
		set_process_input(false)

	#center = get_size() / 2

func _input(event):
	if not visible:
		return

	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			touch_pos = Vector2(event.position.x - 80, event.position.y + 40)
			var player = get_node("../../Player")
			if touch_pos.distance_to(self.position) < button_radius:
				player.shoot("")
				shoot_pressed = true
				boost_pressed = false
			elif touch_pos.distance_to(Vector2(self.position.x + (3 * button_radius), self.position.y)) < button_radius:
				var ev = InputEventAction.new()
				ev.action = "boost"
				ev.pressed = true
				Input.parse_input_event(ev)
				shoot_pressed = false
				boost_pressed = true
				
		else:
			var ev = InputEventAction.new()
			ev.action = "boost"
			ev.pressed = false
			Input.parse_input_event(ev)
				
			
	queue_redraw()

func _draw():
	if not visible:
		return
	const regular_color = Color(0.3, 0.3, 0.3, 0.6)
	const pressed_color = Color(0.7, 0.7, 1, 0.8)
	var shoot_circle = regular_color
	var boost_circle = regular_color
	
	if shoot_pressed:
		shoot_circle = pressed_color
	if boost_pressed:
		boost_circle = pressed_color

	draw_circle(shoot_center, button_radius, shoot_circle)
	draw_circle(boost_center, button_radius, boost_circle)
