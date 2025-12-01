extends Node

@onready var simpleboards = $simpleboards_api
@onready var api_key_path = 'res://data/key.txt'

var uid = "player-0000"
const leaderboard_id : String = "0e253f7a-b1af-436f-34e2-08de26d637f1"
var leaderboard_data : Array = []
var final_time : String = ""

func _ready() -> void:
	# Set the API key
	var api_key = load_file(api_key_path)
	if api_key:
		simpleboards.set_api_key(api_key)
	simpleboards.entries_got.connect(_on_entries_got)
	simpleboards.entry_sent.connect(_on_entry_sent)
	
	SignalBus.leaderboard_data_requested.connect(get_leaderboard_data)
	SignalBus.submit_leaderboard_time.connect(submit_time)
	SignalBus.get_personal_best.connect(detect_personal_best)
	SignalBus.final_time_sent.connect(record_final_time)
	# Send a score
	# Use the hh:mm:ss:SSS format (e.g., 00:12:34:567) 
	#await simpleboards.send_score_without_id("leaderboard_id", "PlayerName", "12345", "[]")
	#await simpleboards.send_score_with_id("leaderboard_id", "PlayerName", "12345", "[]", "1")
	
	# Get leaderboard entries
	#await simpleboards.get_entries("leaderboard_id")

func load_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return null
	var content = file.get_as_text()
	content = content.strip_edges()
	return content


func _on_entries_got(entries):
	leaderboard_data = entries
	SignalBus.leaderboard_data_received.emit(leaderboard_data)
	#for entry in entries:
		##entry.id = "api-key"
		#leaderboard_data = entries
		#print(leaderboard_data)
	
func _on_entry_sent(entry):
	entry.id = "api-key"
	print(entry)

func get_or_create_unique_id() -> String:
	var js = """
	(function() {
		let id = localStorage.getItem('unique_player_id');
		if (!id) {
			id = crypto.randomUUID();
			localStorage.setItem('unique_player_id', id);
		}
		console.log(id);
		return id;
	})()
	"""
	return JavaScriptBridge.eval(js)

#await simpleboards.send_score_with_id("0e253f7a-b1af-436f-34e2-08de26d637f1", "Rylan", "00:12:34:567", "[]", "1")
#await simpleboards.get_entries("0e253f7a-b1af-436f-34e2-08de26d637f1")

func get_leaderboard_data():
	await simpleboards.get_entries(leaderboard_id)

func record_final_time(final_time_got : String):
	final_time = final_time_got

func time_string_to_ms(t: String) -> int:
	# Format: "hh:mm:ss.sss"
	var parts = t.split(":")  # ["hh", "mm", "ss.sss"]
	if parts.size() != 3:
		push_error("Invalid time format: %s" % t)
		return 0

	var hours = int(parts[0])
	var minutes = int(parts[1])

	var sec_parts = parts[2].split(".")  # ["ss", "sss"]
	var seconds = int(sec_parts[0])
	var milliseconds = int(sec_parts[1]) if sec_parts.size() > 1 else 0

	return hours * 3600000 + minutes * 60000 + seconds * 1000 + milliseconds

func detect_personal_best():
	# Get leaderboard data
	get_leaderboard_data()
	await SignalBus.leaderboard_data_received
	
	# Get current run time
	SignalBus.final_time_requested.emit()
	
	# Get the players id
	var unique = get_or_create_unique_id()
	
	var found_previous : bool = false
	var personal_best : bool = true
	
	for entry in leaderboard_data:
		if entry.playerId == unique:
			found_previous = true
			var final_time_ms = time_string_to_ms(final_time)
			var old_time = time_string_to_ms(entry.score.substr(0,11))
			print(final_time_ms, old_time)
			if final_time_ms < old_time:
				personal_best = true
			else:
				personal_best = false
			break
	
	if not found_previous:
		personal_best = true
	
	print("\npersonal_best ", personal_best)
	SignalBus.personal_best_verified.emit(personal_best)


func submit_time(player_name):
	print("\n submit time ", player_name)
	if OS.get_name() == "Web":
		# TODO condense my uniqueid variables with guard statements to not reask the server if not needed?
		var unique_id = get_or_create_unique_id()
		print(unique_id)
		await simpleboards.send_score_with_id(leaderboard_id, player_name, final_time, "[]", unique_id)
	else:
		# TODO add a unique identifier for non web exports
		await simpleboards.send_score_without_id(leaderboard_id, player_name, final_time, "[]")
