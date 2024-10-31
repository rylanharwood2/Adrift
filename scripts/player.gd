extends CharacterBody2D

const SPEED = 130.0

var momentum = 1.
var active_direction = ""

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("move_left", "move_right")
	if (direction != 0):
		active_direction = direction
	
	print(momentum)
	#if Input.is_action_just_pressed("jump"):
	#	pass
		
	# flip the sprite
	#if can_move:
	#	if direction > 0:
	#		animated_sprite.flip_h = false
	#	elif direction < 0:
	#		animated_sprite.flip_h = true
	
	#if direction == 0:
	#		animated_sprite.play("idle")
	
	if momentum > 0:
		momentum -= 0.005
		
	
	
	velocity.x = active_direction * SPEED * momentum
		
	if direction and momentum < 1:
		momentum += 0.01
		
	#elif direction == somethingelse:
	#	velocity.y = direction * SPEED
		
	move_and_slide()
