extends Bullet

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.health == 1:
			body.play_death()
		else:
			body.health -= 1
			if icey:
				body.turn_blue()
		body.flash()

	if body.is_in_group("asteroid"):
		body.play_death()
	
	# free bullet when hitting anything except the player
	if not body.is_in_group("player"):
		queue_free()
