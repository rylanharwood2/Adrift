extends AnimatedSprite2D
class_name bullet


@onready var bullet: AnimatedSprite2D = $"."
@onready var player: CharacterBody2D = get_node("%Player")

var speed = 300.0
var icey = false

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if (body.health == 1):
			body.play_death()
		else:
			body.health -= 1
			if icey:
				body.turn_blue()
		body.flash()
 
	if body.is_in_group("asteroid"):
		body.play_death()
	
	if !body.is_in_group("player"):
		queue_free()
	

func _on_despawn_timer_timeout() -> void:
	# kill the bullets that exit the screen, helps with lag
	queue_free()


func _on_ready() -> void:
	$despawn_timer.start(15)
	
