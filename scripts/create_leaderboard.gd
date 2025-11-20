extends Node

@onready var simpleboards = $simpleboards_api
@onready var api_key_path = 'res://data/key.txt'

var leaderboard_data : Array = []

func _ready() -> void:
	# Set the API key
	simpleboards.set_api_key(load_file(api_key_path))
	simpleboards.entries_got.connect(_on_entries_got)
	simpleboards.entry_sent.connect(_on_entry_sent)
	SignalBus.final_time_sent.connect(submit_time)
	
	# Send a score
	# Use the hh:mm:ss:SSS format (e.g., 00:12:34:567) 
	#await simpleboards.send_score_without_id("leaderboard_id", "PlayerName", "12345", "[]")
	#await simpleboards.send_score_with_id("leaderboard_id", "PlayerName", "12345", "[]", "1")
	
	# Get leaderboard entries
	#await simpleboards.get_entries("leaderboard_id")

func load_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	content = content.strip_edges()
	return content


func _on_entries_got(entries):
	for entry in entries:
		entry.id = "api-key"
		leaderboard_data = entries
		print(leaderboard_data)
	
func _on_entry_sent(entry):
	entry.id = "api-key"
	print(entry)


#await simpleboards.send_score_without_id("0e253f7a-b1af-436f-34e2-08de26d637f1", "Rylan", "00:12:34:567", "[]")
#if event.is_action_pressed("drift(ebrake)"):
#await simpleboards.get_entries("0e253f7a-b1af-436f-34e2-08de26d637f1")
func get_leaderboard_data():
	await simpleboards.get_entries("0e253f7a-b1af-436f-34e2-08de26d637f1")

func submit_time(final_time : String):
	await simpleboards.send_score_without_id("0e253f7a-b1af-436f-34e2-08de26d637f1", "Rylan", final_time, "[]")
