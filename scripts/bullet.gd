extends AnimatedSprite2D

const SPEED = 300

@onready var bullet: AnimatedSprite2D = $"."
@onready var player: CharacterBody2D = %Player


func _physics_process(delta):
	position -= transform.y * SPEED * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if (body.health == 1):
			body.play_death()
		else:
			body.health -= 1
		body.flash()
		queue_free()


func _on_despawn_timer_timeout() -> void:
	# kill the bullets that exit the screen, helps with lag
	queue_free()


func _on_ready() -> void:
	$despawn_timer.start(15)
