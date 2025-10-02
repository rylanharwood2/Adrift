extends CanvasLayer

#@onready var player = get_node("%Player")

	
func display_menu():
	GameManager.set_state(GameManager.GameState.MAIN_MENU)
	get_tree().paused = true
	show()
	$blur_layer.material.set_shader_parameter("amount", 1)


func _on_play_button_pressed() -> void:
	hide()
	get_tree().paused = false
	GameManager.set_state(GameManager.GameState.PLAYING)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
