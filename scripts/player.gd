extends CharacterBody2D

const SPEED = 8000.0
var bullet_type = ""
var holding_direction = ""

@export var health: int = 5
@export var ammo: int = 5

@export var is_colliding: bool = false
@export var is_tilting: bool = false
@export var flame_on_counter : int = 0
@export var idle_couter : int = 0

@export var acceleration: float = 70.0  # Acceleration while pressing forward
#@export var deceleration: float = 0.0   # Deceleration when releasing forward
@export var max_speed: float = 200.0      # Maximum speed the spaceship can reach
@export var friction: float = 0.965        # Friction for gradual slowdown
@export var rotation_speed: float = 1.5        # Rotation speed when pressing a side input

var scene = preload("res://scenes/bullet.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Weapon Mechanics
func shoot(_bullet_typey):
	var bullet = scene.instantiate()
	owner.add_child(bullet)
	bullet.transform = $muzzle.global_transform
	ammo -= 1

func reload():
	if ammo < 5:
		$reload_timer.start()
	
func _on_reload_timer_timeout() -> void:
	ammo += 1

# enemy latch on



# Control Loop
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		if (ammo > 0):
			shoot("")
	
	if $reload_timer.is_stopped() and ammo < 5:
		reload()
		
	var forward_input = Input.is_action_pressed("move_up")
	var directional_input = Input.get_axis("move_left","move_right")

	if forward_input:
		var direction = Vector2(1, 0).rotated(rotation)

		velocity += (direction * acceleration * delta)
		if (velocity.length() > max_speed):
				velocity = velocity.normalized() * max_speed
	elif !forward_input:
		velocity *= friction
	
	if directional_input == -1:
		rotation_degrees -= rotation_speed
	if directional_input == 1:
		rotation_degrees += rotation_speed
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction == 1 and !is_tilting:
		$AnimatedSprite2D.play("tilt_right")
		is_tilting = true
	elif direction == -1 and !is_tilting:
		$AnimatedSprite2D.play("tilt_left")
		is_tilting = true
	if direction == 0:
		$AnimatedSprite2D.play("idle")
		is_tilting = false
		
	
	if Input.is_action_pressed("move_up") and flame_on_counter == 0:
		$flame_on.play("flame_on")
		flame_on_counter += 1
		idle_couter = 0
		#print("ahhh")
	if !Input.is_action_pressed("move_up") and idle_couter == 0:
		$flame_on.play("idle")
		flame_on_counter = 0
		idle_couter += 1
		#print("fuck")
	
	move_and_slide()

func _on_enemy_detector_body_entered(body: Node2D) -> void:
	is_colliding = true
