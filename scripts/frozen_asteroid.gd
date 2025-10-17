extends Asteroid
var frozen_asteroid_scene = load("res://scenes/ice_powerup.tscn")

@onready var game: Node2D = $"../.."


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		var ice_powerup_location = $".".position 
		var ice_powerup = frozen_asteroid_scene.instantiate() 
		
		ice_powerup.position = ice_powerup_location
		
		# TODO this needs to get converted to a signal to the game I think, yikes
		# unless I am misunderstanding
		game.add_child(ice_powerup)
		ice_powerup.add_to_group("ice_powerups")
		
		queue_free()
