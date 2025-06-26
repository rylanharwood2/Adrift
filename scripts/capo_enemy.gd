extends CharacterBody2D

@onready var target = get_tree().current_scene.get_node("Player")
@onready var game_world := get_tree().root.get_node("Game")
var scene = preload("res://scenes/capo_bullet.tscn")

var rand = RandomNumberGenerator.new()

var  SPEED = randf_range(2500.0, 3500.0)
const TURN_SPEED = 3.0 # max turn speed (idk units)
var health: int = 5

var dead: bool = false

var targgg = Vector2(0,0)
var target_angle = Vector2(0,0)

var left_bullet = null
var right_bullet = null


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
	
	if distance_to_player > 250:
		move_and_slide()
	else:
		velocity = -velocity
		move_and_slide()
		
	if left_bullet:
		left_bullet.global_transform = $left_muzzle.global_transform
	if right_bullet:
		right_bullet.global_transform = $right_muzzle.global_transform
	

func shoot(_bullet_typey):
	left_bullet = scene.instantiate()
	right_bullet = scene.instantiate()
	
	game_world.add_child(left_bullet)
	game_world.add_child(right_bullet)
	
	left_bullet.fire_animation_done.connect(_on_left_fire_animation_done)
	right_bullet.fire_animation_done.connect(_on_right_fire_animation_done)
	left_bullet.global_transform = $left_muzzle.global_transform
	right_bullet.global_transform = $right_muzzle.global_transform
	$reload_speed.start()
	
func _on_left_fire_animation_done():
	left_bullet = null

func _on_right_fire_animation_done():
	right_bullet = null

func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.8)
	$flash_timer.start()

func play_death():
	dead = true
	velocity = Vector2(0,0)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	$AnimatedSprite2D.play("death")
	#await get_tree().create_timer(2).timeout  - I feel like this should work but we are instead using a timer
	$death_animation.start(5)

func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)

func _on_death_animation_timeout() -> void:
	queue_free()
