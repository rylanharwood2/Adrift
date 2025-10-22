extends Asteroid
var frozen_asteroid_scene = load("res://scenes/ice_powerup.tscn")


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		var ice_powerup = frozen_asteroid_scene.instantiate() 
		
		ice_powerup.position = global_position
		
		get_tree().get_first_node_in_group("game").add_child(ice_powerup)
		ice_powerup.add_to_group("ice_powerups")
		
		queue_free()


func drop_healthpack():
	pass
