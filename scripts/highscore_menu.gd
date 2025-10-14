extends CanvasLayer

var ticks = 0
var time_start = 0
var time_end = 0
var milliseconds = 0
var total_seconds = 0
var hours = 0
var minutes = 0
var seconds = 0


var time_elapsed = 0.00


# Leaderboard system, store personal high scores in a json like file stored even in between games
# Organize and trim - view high scores in the main menu, other button!
# If we actually want to be cool - this is where we implement a data structure to measure how many points each gets
# and store them in some way in the json
# show timer on death or endgame but only fulltime if "show speedrun timer" is on

func _on_ready() -> void:
	pass
	

func _process(delta: float) -> void:
	milliseconds = Time.get_ticks_msec()
	#minutes = seconds
	display()
	show_scores(false)

func display():
	$scores.text = ticks_to_clock(milliseconds - time_start)
	"""
	await? while user has not pressed quit
		$scores.text = ticks_to_clock(milliseconds)
	hide()
	"""

func ticks_to_clock(milliseconds: int) -> String:
	total_seconds = ( milliseconds - time_start ) / 1000 
	seconds = total_seconds % 60
	hours = total_seconds / 3600
	minutes = ( total_seconds / 60 ) % 60
	#`print(minutes)
	if hours / 10 == 0:
		hours = "0" + str(hours)
	if minutes / 10 == 0:
		minutes = "0" + str(minutes)
	if seconds / 10 == 0:
		seconds = "0" + str(seconds)
		
	return "%s : %s : %s" % [hours, minutes, seconds]
	
func start_timer(start_time_milliseconds: int):
	time_start = start_time_milliseconds
	
func show_scores(visible):
	if visible:
		show()
	else:
		hide()
	
