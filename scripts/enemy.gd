extends CharacterBody2D

var scene = preload("res://scenes/bullet.tscn")

@onready var target = get_tree().current_scene.get_node("Player")

const SPEED = 4000
const TURN_SPEED = 2.0 # max turn speed (idk units)
var health: int = 2

func player_hit():
	pass
	#if %Player.is_colliding():
	#	$AnimatedSprite2D.pause()
		
func shoot(_bullet_typey):
	var bullet = scene.instantiate()
	owner.add_child(bullet)
	bullet.transform = $Muzzle.global_transform

func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.8)
	$flash_timer.start()

func _process(delta: float) -> void:
	
	var targgg = target.position
	#var direction = (targgg-position).normalized()
	#look_at(target.position)
	#velocity = direction * SPEED * delta
	var target_angle = (targgg - position).angle()
	
	# limit rotation speed
	rotation = lerp_angle(rotation, target_angle, TURN_SPEED * delta)
	
	# move in dir the enemy is facing
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * SPEED * delta


	#if health != 2:
	#	$ProgressBar.value = 1
	
	move_and_slide()


func _on_timer_timeout() -> void:
	pass
	#	shoot("")

func _on_ready() -> void:
	flash()
	#$ProgressBar.value = health

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.health -= 1
		print("successful")
		

func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)
