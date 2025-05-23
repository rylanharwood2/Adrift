extends CanvasLayer

#@onready var player: CharacterBody2D = %Player

signal start_game

func show_message(text):
	$start_message.text = text
	$start_message.show()
	$message_timer.start()

func update_health(health_update:int):
	$health.text = "Health [ " + str(health_update) + " ]"#%Player.health) + " ]"

func update_ammo(ammo_update:int):
	$ammo.text = "Ammo [ " + str(ammo_update) + " ]"

func update_boost_meter():
	$boost.text = "Boost [ " + str(int(%Player.boost_meter)) + " ]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_message_timer_timeout() -> void:
	$start_message.hide()
