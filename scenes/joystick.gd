extends Control

# Appearance
var base_radius := 60
var knob_radius := 30
var max_distance := 50

# State
var dragging := false
var center := Vector2.ZERO
var touch_pos := Vector2.ZERO
var direction := Vector2.ZERO

func _ready():
	# Only enable joystick on touchscreen devices
	if DisplayServer.is_touchscreen_available():
		visible = true
		set_process_input(true)
	else:
		visible = false
		set_process_input(false)

	center = get_size() / 2

func _input(event):
	if not visible:
		return

	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			print(event.position, " ", self.position)
			if self.position.y - 60 > event.position.y and event.position.y > self.position.y - 60 - base_radius:
				var ev := InputEventAction.new()
				ev.action = "move_up"
				ev.pressed = true
				Input.parse_input_event(ev)
				dragging = true
				direction.y = 30
			if self.position.x - 60 - 20> event.position.x and event.position.x > self.position.x - 60 - base_radius:
				var ev := InputEventAction.new()
				ev.action = "move_left"
				ev.pressed = true
				dragging = true
				Input.parse_input_event(ev)
				direction.x = -30
			elif self.position.x - 60 + 20 < event.position.x and event.position.x < self.position.x - 60 + base_radius:
				print("Moving right")
				var ev := InputEventAction.new()
				ev.action = "move_right"
				ev.pressed = true
				dragging = true
				Input.parse_input_event(ev)
				direction.x = 30
				
			
		elif not event.pressed:
			var ev := InputEventAction.new()
			ev.action = "move_left"
			ev.pressed = false
			Input.parse_input_event(ev)
			var ev1 := InputEventAction.new()
			ev1.action = "move_right"
			ev1.pressed = false
			Input.parse_input_event(ev1)
			var ev2 := InputEventAction.new()
			ev2.action = "move_up"
			ev2.pressed = false
			Input.parse_input_event(ev2)
			dragging = false
			direction = Vector2(0, 0)
	elif event is InputEventScreenDrag or event is InputEventMouseMotion and dragging:
		touch_pos = event.position
		direction = (touch_pos - global_position - center)
		if direction.length() > max_distance:
			direction = direction.normalized() * max_distance
			
	queue_redraw()

func _draw():
	if not visible:
		return

	# Draw base
	draw_circle(center, base_radius, Color(0.3, 0.3, 0.3, 0.6))

	# Draw knob
	var knob_center = center + direction
	draw_circle(knob_center, knob_radius, Color(0.7, 0.7, 1, 0.8))
	

func get_normalized_direction():
	return direction / max_distance
