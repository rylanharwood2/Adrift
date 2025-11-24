extends Panel

var ability_list : Array[String] = ["proxy_mine", "ice_powerup", "forcefield"]

func _ready() -> void:
	hide()
	SignalBus.display_reward_menu.connect(display_menu)
	SignalBus.select_upgrade_reward.connect(undisplay_menu)



func display_menu():
	if not $VBoxContainer/new_ability_button or ability_list.size() <= 0:
		$VBoxContainer/new_ability_button.queue_free()
	show()


func undisplay_menu():
	hide()


func _on_max_health_button_pressed() -> void:
	SignalBus.change_max_health.emit(2)
	SignalBus.select_upgrade_reward.emit()


func _on_new_ability_button_pressed() -> void:
	var random_ability = ability_list.pick_random()
	ability_list.remove_at(ability_list.find(random_ability))
	SignalBus.add_new_ability.emit(random_ability)
	SignalBus.select_upgrade_reward.emit()
