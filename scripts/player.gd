extends CharacterBody2D

const SPEED = 8000.0
var bullet_type = ""

var scene = preload("res://scenes/bullet.tscn")

func shoot(_bullet_typey):
	#var scene = load("res://scenes/bullet.tscn")
	var bullet = scene.instantiate()
	#bullet.position = $Marker2D.global_position()
	owner.add_child(bullet)
	bullet.transform = $Marker2D.global_transform
	print("created bullet")
	

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right", "move_up", "move_down")
	
	if direction: 
		velocity = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if Input.is_action_just_pressed("shoot"):
		shoot("")
			
	move_and_slide()
