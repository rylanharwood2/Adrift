extends StaticBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	pass
	
func play_death() -> void:
	$AnimatedSprite2D.play("death")
	

func _on_animated_sprite_2d_animation_finished() -> void:
	print("ah shit")
	if $AnimatedSprite2D.animation == "death":
		queue_free()
