extends CharacterBody2D

var scene = preload("res://scenes/bullet.tscn")

@onready var target = get_tree().current_scene.get_node("Player")

const SPEED = 4000
var health: int = 2

func player_hit():
	pass
	#if %Player.is_colliding():
	#	$AnimatedSprite2D.pause()
		
func shoot(_bullet_typey):
	var bullet = scene.instantiate()
	owner.add_child(bullet)
	bullet.transform = $Muzzle.global_transform


func _process(delta: float) -> void:
	
	var targgg = target.position
	var direction = (targgg-position).normalized()
	velocity = direction * SPEED * delta
	look_at(target.position)
	
	#if health != 2:
	#	$ProgressBar.value = 1
	
	move_and_slide()


func _on_timer_timeout() -> void:
	pass
	#	shoot("")

func _on_ready() -> void:
	pass
	#$ProgressBar.value = health

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.health -= 1
		print("successful")
