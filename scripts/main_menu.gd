extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO show the pause screen and pause the game when escape is pressed, turn it off when start is pressed
	if Input.is_action_just_pressed("pause"):
		show()
		get_tree().paused = true
		$blur_layer.material.set_shader_parameter("amount", 1)
	elif $VBoxContainer/start_button.is_pressed():
		get_tree().paused = false
		hide()
	elif $VBoxContainer/quit_button.is_pressed():
		get_tree().quit()
		
