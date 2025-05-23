extends CharacterBody2D

@onready var target = get_tree().current_scene.get_node("Player")
var scene = preload("res://scenes/bullet.tscn")

var rand = RandomNumberGenerator.new()

var  SPEED = randf_range(2500.0, 3500.0)
const TURN_SPEED = 3.0 # max turn speed (idk units)
var health: int = 5

var dead: bool = false

var targgg = Vector2(0,0)
var target_angle = Vector2(0,0)


func _ready() -> void:
	flash()
	

func _process(delta: float) -> void:
	var direction = Vector2(cos(rotation), sin(rotation))
	var distance_to_player = (0)
	if !dead: 
		targgg = target.position
		distance_to_player = self.position.distance_to(targgg)
		target_angle = (targgg - position).angle()
		
		# limit rotation speed
		rotation = lerp_angle(rotation, target_angle, TURN_SPEED * delta)
	
		# move in dir the enemy is facing
		velocity = direction * SPEED * delta
		
	if (!dead and $reload_speed.is_stopped()):
		shoot("")
	
	if dead:
		velocity = Vector2(0,0)
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		queue_free()
	
	if distance_to_player > 250:
		move_and_slide()
	else:
		velocity = -velocity
		move_and_slide()
	
	

func shoot(_bullet_typey):
	var bullet = scene.instantiate()
	bullet.speed *= 2
	
	owner.add_child(bullet)
	bullet.transform = $muzzle.global_transform
	$reload_speed.start()
	

func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.8)
	$flash_timer.start()

func play_death():
	dead = true
	if dead:
		queue_free()
		#$AnimatedSprite2D.play("death")


func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)
