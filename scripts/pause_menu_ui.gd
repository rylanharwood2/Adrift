extends CanvasLayer

func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		match GameManager.current_state:
			GameManager.GameState.PLAYING:
				open_pause_menu()
			GameManager.GameState.PAUSED:
				close_pause_menu()
			GameManager.GameState.MAIN_MENU:
				pass

func open_pause_menu():
	show()
	get_tree().paused = true
	GameManager.set_state(GameManager.GameState.PAUSED)
	$blur_layer.material.set_shader_parameter("amount", 1)

func close_pause_menu():
	get_tree().paused = false
	hide()
	GameManager.set_state(GameManager.GameState.PLAYING)


func _on_start_button_pressed() -> void:
	close_pause_menu()

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
