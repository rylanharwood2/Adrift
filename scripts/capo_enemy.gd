#extends CharacterBody2D
extends Creature

# TODO do finding the player with a signal instead
@onready var target = get_tree().current_scene.get_node("Player")
@onready var game_world := get_tree().root.get_node("Game")
var scene = preload("res://scenes/capo_bullet.tscn")

var rand = RandomNumberGenerator.new()

var  speed = randf_range(2500.0, 3500.0)
const TURN_SPEED = 3.0 # max turn speed (idk units)
# health: int = 4

var target_position = Vector2(0,0)
var target_angle = Vector2(0,0)

var direction = Vector2(cos(rotation), sin(rotation))
var distance_to_player = (0)

var left_bullet = null
var right_bullet = null

var player_node = null


func _ready() -> void:
	flash()
	

func _process(delta: float) -> void:
	if dead:
		return
	
	target_position = target.position
	distance_to_player = self.position.distance_to(target_position)
	target_angle = (target_position - position).angle()
	
	# limit rotation speed
	rotation = lerp_angle(rotation, target_angle, TURN_SPEED * delta * speed_mod)

	# move in dir the enemy is facing
	velocity = direction * speed * delta * speed_mod
		
	if $reload_speed.is_stopped():
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
	left_bullet.speed_mod = speed_mod
	right_bullet.global_transform = $right_muzzle.global_transform
	right_bullet.speed_mod = speed_mod
	
	if speed_mod < 1:
		left_bullet.material.set_shader_parameter("blue", true)
		right_bullet.material.set_shader_parameter("blue", true)
	$reload_speed.start()
	
func _on_left_fire_animation_done():
	left_bullet = null

func _on_right_fire_animation_done():
	right_bullet = null


func turn_blue():
	$ship.material.set_shader_parameter("blue", true)
	$ice_timer.start()
	speed_mod = 0.5


func _on_ice_timer_timeout() -> void:
	speed_mod = 1.0
	$ship.material.set_shader_parameter("blue", false)


func _on_ship_animation_finished() -> void:
	if $ship.animation == "death":
		queue_free()


# enemy on hit damage {
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hurt_player(1)
		player_node = body
		$hit_cooldown.start(1.0)


func _on_area_2d_body_exited(body: Node2D) -> void:
	player_node = null


func _on_hit_cooldown_timeout() -> void:
	if player_node:
		player_node.hurt_player(1)
		$hit_cooldown.start(1.0)
# }
