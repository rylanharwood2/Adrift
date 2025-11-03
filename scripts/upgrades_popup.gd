extends Panel


func _ready() -> void:
	hide()
	SignalBus.display_reward_menu.connect(display_menu)
	SignalBus.select_upgrade_reward.connect(undisplay_menu)



func display_menu():
	show()
	
func undisplay_menu():
	hide()
