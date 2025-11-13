extends CanvasLayer

func show_message(text, dead: bool = false):	
	$start_message.text = text
	$start_message.show()
	if !dead:
		$message_timer.start()

func display_healthbar(new_health : int):
	var healthbar_ratio = new_health / 8. # max health at the moment
	healthbar_ratio = (floor(healthbar_ratio*10))
	$healthbar_sprite.frame = healthbar_ratio

func update_health(health_update:int):
	$health.text = "Health [ " + str(health_update) + " ]"

func update_ammo(ammo_update:int):
	$ammo.text = "Ammo [ " + str(ammo_update) + " ]"

func update_boost_meter(boost_update:float):
	$boost.text = "Boost [ " + str(int(boost_update)) + " ]"


func _ready() -> void:
	SignalBus.player_died.connect(show_message)
	SignalBus.health_changed.connect(display_healthbar)
	SignalBus.ammo_changed.connect(update_ammo)
	SignalBus.boost_changed.connect(update_boost_meter)
	SignalBus.ability_used.connect(start_powerup_cooldown)
	SignalBus.add_new_ability.connect(enable_ability_icon)
	
	

func _init() -> void:
	hide()

func start_powerup_cooldown(powerup):
	if powerup == "proxy_mine":
		$proxy_mine_icon/AnimationPlayer.play("cooldown")
	elif powerup == "forcefield":
		$forcefield_icon/AnimationPlayer.play("cooldown")
	elif powerup == "ice_powerup":
		$ice_powerup_icon/AnimationPlayer.play("cooldown")
	

func _process(_delta: float) -> void:
	if get_tree().paused == true:
		hide()
	else:
		show()

func enable_ability_icon(ability : String):
	if ability == "proxy_mine":
		$proxy_mine_icon.show()
	if ability == "ice_powerup":
		$ice_powerup_icon.show()
	if ability == "forcefield":
		$forcefield_icon.show()
		

func _on_message_timer_timeout() -> void:
	$start_message.hide()
