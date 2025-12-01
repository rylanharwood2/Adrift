extends CanvasLayer

var player_died : bool = false

func show_message(text):
	if not player_died:
		$message_timer.start()
		
	$start_message.text = text
	$start_message.show()
	
	
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
	SignalBus.player_died.connect(death_screen)
	SignalBus.health_changed.connect(display_healthbar)
	SignalBus.ammo_changed.connect(update_ammo)
	SignalBus.boost_changed.connect(update_boost_meter)
	SignalBus.ability_used.connect(start_powerup_cooldown)
	SignalBus.add_new_ability.connect(enable_ability_icon)
	
	

func _init() -> void:
	hide()
	player_died = false

func death_screen():
	player_died = true
	show_message("You Died!\nPress R to Restart")

func start_powerup_cooldown(weapon_equipped : String):
	if weapon_equipped == "spreader":
		$forcefield_icon/TextureProgressBar.value = 100
		$proxy_mine_icon/TextureProgressBar.value = 0
		$ice_powerup_icon/TextureProgressBar.value = 0
		#$proxy_mine_icon/AnimationPlayer.play("cooldown")
	elif weapon_equipped == "homing_missile":
		$forcefield_icon/TextureProgressBar.value = 0
		$proxy_mine_icon/TextureProgressBar.value = 100
		$ice_powerup_icon/TextureProgressBar.value = 0
		#$forcefield_icon/AnimationPlayer.play("cooldown")
	elif weapon_equipped == "railgun":
		$forcefield_icon/TextureProgressBar.value = 0
		$proxy_mine_icon/TextureProgressBar.value = 0
		$ice_powerup_icon/TextureProgressBar.value = 100
		#$ice_powerup_icon/AnimationPlayer.play("cooldown")
	

func _process(_delta: float) -> void:
	# TODO set this to a signal when the game is paused
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
