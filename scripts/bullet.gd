extends AnimatedSprite2D

const SPEED = 400

func _physics_process(delta):
	position -= transform.y * SPEED * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
