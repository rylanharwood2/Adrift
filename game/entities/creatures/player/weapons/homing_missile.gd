extends Weapon

@onready var rocket = $rocket_sprite
@export var speed = 200
@export var steer_force = 20

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func _ready() -> void:
	super()
	rotation += randf_range(-0.09, 0.09)
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	$despawn_timer.start(6)
	
func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.limit_length(speed)
	rotation = velocity.angle()
	position += velocity * delta
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") or body.is_in_group("boss") or body.is_in_group("asteroid"):
		explode()
		deal_damage(body)
	

func _on_despawn_timer_timeout() -> void:
	explode()
	
func explode():
	set_physics_process(false)
	$rocket_sprite.play("explode")
	await $rocket_sprite.animation_finished
	queue_free()
	
func deal_damage(body: Node2D):
	if body.is_in_group("enemies"):
		body.adjust_health(2)
	elif body.is_in_group("asteroid"):
		body.play_death()
	
