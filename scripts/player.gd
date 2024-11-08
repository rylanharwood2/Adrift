extends CharacterBody2D

const SPEED = 8000.0
var bullet_type = ""
var holding_direction = ""

@export var acceleration: float = 70.0  # Acceleration while pressing forward
@export var deceleration: float = 0.0   # Deceleration when releasing forward
@export var max_speed: float = 200.0      # Maximum speed the spaceship can reach
@export var friction: float = 0.965        # Friction for gradual slowdown

var scene = preload("res://scenes/bullet.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



func shoot(_bullet_typey):
	var bullet = scene.instantiate()
	owner.add_child(bullet)
	bullet.transform = $Muzzle.global_transform
	print("created bullet")
	

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		shoot("")
		
	var forward_input = Input.is_action_pressed("move_up")
	var directional_input = Input.get_axis("move_left","move_right")

	if forward_input:
		var direction = Vector2(1, 0).rotated(rotation)

		velocity += (direction * acceleration * delta)
		if (velocity.length() > max_speed):
				velocity = velocity.normalized() * max_speed
		print(velocity)
	elif !forward_input:
		velocity *= friction
	
	
	if directional_input == -1:
		rotation_degrees -= 1.5
	if directional_input == 1:
		rotation_degrees += 1.5
	
	move_and_slide()
