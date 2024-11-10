extends Node2D

var current_player_health : int = -1
var current_player_ammo : int = -1

func new_game():
	$HUD.show_message("Welcome to the \nThunderdome!!")
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if %Player.health != current_player_health:
		current_player_health = %Player.health
		$HUD.update_health(%Player.health)
	if %Player.ammo != current_player_ammo:
		current_player_ammo = %Player.ammo
		$HUD.update_ammo(%Player.ammo)
		print(%Player.ammo)
