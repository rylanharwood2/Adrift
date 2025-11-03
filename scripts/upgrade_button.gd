extends Button


func _on_pressed() -> void:
	if text == "Increase Max Health":
		health_button()
	if text == "Add New Ability":
		ability_button()
		
	SignalBus.select_upgrade_reward.emit()

func health_button():
	SignalBus.change_max_health.emit(2)

func ability_button():
	SignalBus.add_new_ability.emit("proxy_mine")
