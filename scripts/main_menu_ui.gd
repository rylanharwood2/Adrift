extends CanvasLayer

@onready var player = get_node("%Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#$big_bad_dude.bam.connect(display_menu)
	#player.dead.connect("display_menu") #
	
	#$big_bad_dude.bam.disconnect(display_menu)
	# TODO connect to player dead signal
	#if Input.is_action_just_pressed("pause"):
		#show()
		#get_tree().paused = true
		#$blur_layer.material.set_shader_parameter("amount", 1)
	#elif $VBoxContainer/start_button.is_pressed():
		#get_tree().paused = false
		#hide()
	#elif $VBoxContainer/quit_button.is_pressed():
		#get_tree().quit()
		#

func display_menu():
	print("player dead")
	$big_bad_dude.bam.disconnect(display_menu)
