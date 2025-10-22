extends CanvasLayer

#@onready var player: CharacterBody2D = %Player

func show_message(text, dead: bool = false):	
	$start_message.text = text
	$start_message.show()
	if !dead:
		$message_timer.start()

func display_healthbar(new_health : int):
	
	print(new_health)
	var healthbar_ratio = new_health / 8. # max health at the moment
	healthbar_ratio = (floor(healthbar_ratio*10))
	$healthbar_sprite.frame = healthbar_ratio

func update_health(health_update:int):
	$health.text = "Health [ " + str(health_update) + " ]"#%Player.health) + " ]"

func update_ammo(ammo_update:int):
	$ammo.text = "Ammo [ " + str(ammo_update) + " ]"

func update_boost_meter(boost_update:float):
	$boost.text = "Boost [ " + str(int(boost_update)) + " ]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_died.connect(show_message)
	SignalBus.health_changed.connect(display_healthbar)
	SignalBus.ammo_changed.connect(update_ammo)
	SignalBus.boost_changed.connect(update_boost_meter)
	

func _init() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_tree().paused == true:
		hide()
	else:
		show()



func _on_message_timer_timeout() -> void:
	$start_message.hide()
