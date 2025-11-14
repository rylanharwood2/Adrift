extends Weapon

@onready var rocket = $rocket_sprite
@export var speed = 200
@export var steer_force = 25

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func _ready() -> void:
	super()
	rotation += randf_range(-0.09, 0.09)
	velocity = velocity.x * speed
	target = get_tree().get_first_node_in_group("enemies")
	
func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta
	

func _on_body_entered(body: Node2D) -> void:
	explode()


func _on_despawn_timer_timeout() -> void:
	explode()
	
func explode():
	set_physics_process(false)
	$rocket_sprite.play("explode")
	await $rocket_sprite.animation_finished
	queue_free()
