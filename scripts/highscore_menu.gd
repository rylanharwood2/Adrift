extends CanvasLayer

var entry_name_text  : String = ""
var entry_score_text : String = ""
var entry_date_text  : String = ""

@onready var horizontal_box_scene = preload("res://scenes/horizontal_scores_container.tscn")

func _on_ready() -> void:
	hide()
	

func _process(_delta: float) -> void:
	pass


func display_leaderboard():
	show()
	SignalBus.leaderboard_data_requested.emit()
	var formatted_leaderboard_data : Array = await SignalBus.leaderboard_data_received
	$loading_text.hide()
	for entry in formatted_leaderboard_data:
		var horizontal_box = horizontal_box_scene.instantiate()
		horizontal_box.set_name_label(entry.playerDisplayName)
		horizontal_box.set_score_label(entry.score.substr(0,11))
		horizontal_box.set_date_label(iso_utc_to_pst(entry.createdAt))
		$vertical_scores_container.add_child(horizontal_box)
	
func _on_show_timer_pressed() -> void:
	pass

func iso_utc_to_pst(iso: String) -> String:
	var unix_utc := Time.get_unix_time_from_datetime_string(iso)
	var unix_pst := unix_utc - 8 * 3600
	var dt := Time.get_datetime_dict_from_unix_time(unix_pst)

	# Format output: YYYY-MM-DD HH:MM:SS PST
	return "%02d/%02d/%04d" % [
		dt.month,
		dt.day,
		dt.year
	]


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
