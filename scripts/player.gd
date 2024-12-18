extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# TODO universal random number seed?
var rng = RandomNumberGenerator.new()

@export var health: int = 5
@export var ammo_cap: int = 10
@export var ammo: int = 10

@export var flame_on_counter : int = 0
@export var idle_couter : int = 0

@export var acceleration: float = 90.0  	## Acceleration while pressing forward
@export var max_speed: float = 200.0      	## Maximum speed the spaceship can reach
@export var friction: float = 0.99        	## Friction for gradual slowdown
@export var rotation_speed: float = 2    	## Rotation speed when pressing a side input
@export var boost_meter: float = 100.0


const SPEED = 8000.0

var bullet_type = ""
var holding_direction = ""
var is_colliding: bool = false
var is_tilting: bool = false
var is_boosting: bool = false
var is_boost_recharging: bool = true
var rotation_direction = 0

var scene = preload("res://scenes/bullet.tscn")

## Weapon Mechanics
func shoot(_bullet_typey):
	var bullet = scene.instantiate()
	$shoot_sound.set_pitch_scale(rng.randf_range(0.95, 1.25))
	$shoot_sound.play()
	owner.add_child(bullet)
	bullet.transform = $muzzle.global_transform
	ammo -= 1

func reload():
	if ammo < ammo_cap:
		$reload_timer.start()

func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.8)
	$flash_timer.start()

# boooooooooost
func boost() -> void:
	if boost_meter > 0:
		velocity += (rotation_direction * acceleration * 0.25)
		boost_meter -= 0.4
	if (velocity.length() > max_speed):
		velocity = velocity.normalized() * max_speed

func play_tilting_animation() -> void:
	var tilting_direction = Input.get_axis("move_left", "move_right")
	if tilting_direction == 1 and !is_tilting:
		$AnimatedSprite2D.play("tilt_right")
		is_tilting = true
	elif tilting_direction == -1 and !is_tilting:
		$AnimatedSprite2D.play("tilt_left")
		is_tilting = true
	if tilting_direction == 0:
		$AnimatedSprite2D.play("idle")
		is_tilting = false

func play_flame_amimation() -> void:
	# TODO make flame_on_counter / idle_counter into one variable
	var flame_on = Input.is_action_pressed("move_up") or Input.is_action_pressed("boost") # FLAME ON!
	if flame_on and flame_on_counter == 0:
		$flame_on.play("flame_on")
		flame_on_counter += 1
		idle_couter = 0
	if !flame_on and idle_couter == 0:
		$flame_on.play("idle")
		flame_on_counter = 0
		idle_couter += 1

func _on_ready() -> void:
	$ship_startup.play()
	$invulnerability_frames.start()

# Control Loop
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		if (ammo > 0):
			shoot("")
	
	if $reload_timer.is_stopped() and ammo < ammo_cap:
		reload()
	
	var forward_input = Input.is_action_pressed("move_up")
	var boost_input = Input.is_action_pressed("boost")
	var directional_input = Input.get_axis("move_left","move_right")
	
	rotation_direction = Vector2(1, 0).rotated(rotation)
	
	if forward_input:
		velocity += (rotation_direction * acceleration * delta)
		if (velocity.length() > max_speed):
			velocity = velocity.normalized() * max_speed
	elif !forward_input:
		velocity *= friction
	
	if directional_input == -1:
		rotation_degrees -= rotation_speed
	if directional_input == 1:
		rotation_degrees += rotation_speed
	
	play_tilting_animation()
	play_flame_amimation()
	
	if Input.is_action_pressed("boost") and boost_meter > 0:
		is_boost_recharging = false
		$boost_cooldown_timer.start()
		is_boosting = true
		max_speed = 300.0
		boost()
	elif !Input.is_action_pressed("boost"):
		max_speed = 200.0
		is_boosting = false
		if boost_meter < 100 and is_boost_recharging:
			boost_meter += 0.4
	
	move_and_slide()

func _on_enemy_detector_body_entered(body: Node2D) -> void:
	# TODO allow them to hit you again if they are still attached
	if ($invulnerability_frames.is_stopped() and body.is_in_group("enemies")):
		$invulnerability_frames.start()
		$player_hurt.play()
		flash()
		health -= 1


func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)

func _on_reload_timer_timeout() -> void:
	ammo += 1
	
func _on_boost_cooldown_timer_timeout() -> void:
	is_boost_recharging = true
