extends CharacterBody2D

var scene = preload("res://scenes/bullet.tscn")

@onready var target = get_tree().current_scene.get_node("Player")

const SPEED = 4000
var health: int = 2
var dead: bool = false

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

func play_death():
	dead = true
	if dead:
		$AnimatedSprite2D.play("death")
		$AnimationPlayer.play("death")

func _process(delta: float) -> void:
	var direction = (target.position-position).normalized()
	velocity = direction * SPEED * delta
	look_at(target.position)
	
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
