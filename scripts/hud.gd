extends CanvasLayer

#@onready var player: CharacterBody2D = %Player

signal start_game


func show_message(text, dead: bool = false):	
	$start_message.text = text
	$start_message.show()
	if !dead:
		$message_timer.start()

func update_health(health_update:int):
	$health.text = "Health [ " + str(health_update) + " ]"#%Player.health) + " ]"

func update_ammo(ammo_update:int):
	$ammo.text = "Ammo [ " + str(ammo_update) + " ]"

func update_boost_meter(boost_update:float):
	$boost.text = "Boost [ " + str(int(boost_update)) + " ]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game.emit()

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
