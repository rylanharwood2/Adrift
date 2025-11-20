extends CanvasLayer

var entry_name_text  : String = ""
var entry_score_text : String = ""
var entry_date_text  : String = ""

func _on_ready() -> void:
	hide()
	

func _process(_delta: float) -> void:
	pass


func display_leaderboard():
	show()
	SignalBus.leaderboard_data_requested.emit() #await $leaderboard.get_leaderboard_data()
	print("data requested")
	var formatted_leaderboard_data : Array = await SignalBus.leaderboard_data_received
	print("displayable data ready")
	$loading_text.hide()
	print(formatted_leaderboard_data)
	for entry in formatted_leaderboard_data:
		$scores_container/entry_name.text += entry.playerDisplayName + '\n'
		$scores_container/entry_score.text += entry.score.substr(0,11) + '\n'
		$scores_container/entry_date.text += iso_utc_to_pst(entry.createdAt) + '\n'
		
	
func _on_show_timer_pressed() -> void:
	pass

func iso_utc_to_pst(iso: String) -> String:
	var unix_utc := Time.get_unix_time_from_datetime_string(iso)
	var unix_pst := unix_utc - 8 * 3600
	var dt := Time.get_datetime_dict_from_unix_time(unix_pst)

	# Format output: YYYY-MM-DD HH:MM:SS PST
	return "%04d-%02d-%02d %02d:%02d:%02d PST" % [
		dt.year,
		dt.month,
		dt.day,
		dt.hour,
		dt.minute,
		dt.second,
	]


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
