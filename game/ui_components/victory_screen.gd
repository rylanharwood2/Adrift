extends CanvasLayer

func _ready() -> void:
	SignalBus.game_finished.connect(detect_personal_best)

func display_victory_scene(new_personal_best: bool):
	#get_tree().paused = true
	$blur_layer.material.set_shader_parameter("amount", 1)
	show()
	
#
	#
	#var final_time = await SignalBus.get_final_time
	#if best:
		
		#await get_player_name
		#emit send_time
		#show button to leaderboard screen
		#
	#else:
		#$victory_text.text = "YOU WIN\n\nFinal Time : " + final_time


func detect_personal_best():
	
	SignalBus.get_personal_best.emit()
	var was_best : bool = await SignalBus.personal_best_verified
	print("was_best", was_best)
	display_victory_scene(true)
	if was_best == true:
		$input_field.show()
		print("they get a new entry now pls")
		var player_name = await SignalBus.submit_player_text_input
		SignalBus.submit_leaderboard_time.emit(player_name)
	else:
		print("no new entry for them")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/global_ish/game.tscn")
