extends CharacterBody2D

var scene = preload("res://scenes/bullet.tscn")

@onready var target = get_tree().current_scene.get_node("Player")
const SPEED=4000


func player_hit():
	if %Player.is_colliding():
		pass
		#$AnimatedSprite2D.pause()
		
func shoot(_bullet_typey):
	var bullet = scene.instantiate()
	owner.add_child(bullet)
	bullet.transform = $Muzzle.global_transform
	#print("created bullet")

func _process(delta: float) -> void:
	
	var targgg = target.position
	var direction = (targgg-position).normalized()
	velocity = direction * SPEED * delta
	look_at(target.position)
	
	move_and_slide()

func _on_timer_timeout() -> void:
	pass
	#	shoot("")
