extends CharacterBody2D

var scene = preload("res://scenes/bullet.tscn")
@onready var target=$"../Player"
const SPEED=3000

func shoot(_bullet_typey):
	var bullet = scene.instantiate()
	owner.add_child(bullet)
	bullet.transform = $Muzzle.global_transform
	print("created bullet")

func _process(delta: float) -> void:
	var direction = (target.position-position).normalized()
	velocity = direction * SPEED * delta
	look_at(target.position)
	
	move_and_slide()

func _on_timer_timeout() -> void:
	shoot("")
