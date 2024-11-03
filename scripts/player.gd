extends CharacterBody2D

const SPEED = 8000.0
var bullet_type = ""
var holding_direction = ""

var scene = preload("res://scenes/bullet.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func shoot(_bullet_typey):
	var bullet = scene.instantiate()
	owner.add_child(bullet)
	bullet.transform = $Muzzle.global_transform
	print("created bullet")
	

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right", "move_up", "move_down")
	
	if direction: 
		velocity = direction * SPEED * delta
		if direction[0] == -1 and holding_direction != "left":
			animated_sprite.play("tilt_left")
			holding_direction = "left"
		if direction[0] == 1 and holding_direction != "right":
			animated_sprite.play("tilt_right")
			holding_direction = "right"
		if direction[1] == 1:
			pass
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		holding_direction = ""
		animated_sprite.play("idle")
		
		
	if Input.is_action_just_pressed("shoot"):
		shoot("")
			
	move_and_slide()
