extends AnimatedSprite2D
class_name Bullet

var speed: float = 300.0
var icey: bool = false

func _physics_process(delta: float) -> void:
	position -= transform.y * speed * delta

func _on_despawn_timer_timeout() -> void:
	# kill the bullets that exit the screen, helps with lag
	queue_free()

func _ready() -> void:
	# start a despawn timer when the bullet is created
	$despawn_timer.start(10)
