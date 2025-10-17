class_name Asteroid
extends Node


func play_death() -> void:
	$AnimatedSprite2D.play("death")
	#$CollisionShape2D.disabled = true    # Does not work
	$CollisionShape2D.set_deferred("disabled", true) # Works
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		queue_free()
