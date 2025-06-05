extends CharacterBody2D

var scene = preload("res://scenes/bullet.tscn")

@onready var target = get_tree().current_scene.get_node("Player")

var rand = RandomNumberGenerator.new()

var  SPEED = randf_range(3500.0, 4500.0)
const TURN_SPEED = 2.0 # max turn speed (idk units)
var health: int = 2
var dead: bool = false

var targgg = Vector2(0,0)
var target_angle = Vector2(0,0)


func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.8)
	$flash_timer.start()

func play_death():
	dead = true
	if dead:
		$AnimatedSprite2D.play("death")
		$AnimationPlayer.play("death")


func _process(delta: float) -> void:
	var direction = Vector2(cos(rotation), sin(rotation))
	if !dead:
		targgg = target.position
		target_angle = (targgg - position).angle()
		
		#var direction = (targgg-position).normalized()
		#velocity = direction * SPEED * delta
	
	# limit rotation speed
		rotation = lerp_angle(rotation, target_angle, TURN_SPEED * delta)
	
	# move in dir the enemy is facing
	
		velocity = direction * SPEED * delta

	if dead:
		velocity = Vector2(0,0)
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
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


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		queue_free()
