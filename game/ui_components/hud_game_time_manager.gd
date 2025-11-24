extends Control

var total_ms : int = 0
var hours   : int = 0
var minutes : int = 0
var seconds : int = 0
var milliseconds : int = 0


var increment_timer : bool = true
var time_elapsed : float = 0.0


func _ready() -> void:
	SignalBus.final_time_requested.connect(send_time)
	SignalBus.gamestate_changed.connect(_on_state_changed)

func _process(delta: float) -> void:
	if increment_timer:
		time_elapsed += delta
		$in_game_timer.text = format_time()
	
	
func show_scores(currently_visible):
	if currently_visible:
		$in_game_timer.show()
	else:
		$in_game_timer.hide()


func _on_state_changed(_new_state):
	if GameManager.current_state == GameManager.GameState.PLAYING:
		increment_timer = true
	else:
		increment_timer = false
	

func format_time() -> String:
	total_ms = int(round(time_elapsed * 1000.))
	
	hours = total_ms / 3600000
	minutes = (total_ms / 60000) % 60
	seconds = (total_ms / 1000) % 60
	milliseconds = total_ms % 1000
	
	return "%02d:%02d:%02d.%03d" % [hours, minutes, seconds, milliseconds]
	
func send_time():
	# 00:12:34.567
	var final_time = "%s:%s:%s.%s" % [hours, minutes, seconds, milliseconds]
	SignalBus.final_time_sent.emit(final_time)
	print("final_time_sent", final_time)
