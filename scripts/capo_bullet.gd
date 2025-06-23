extends "res://scripts/bullet.gd"

var bullet_damage = 1

func play_explosion_animation():
	$".".play("fire")
	await get_tree().create_timer(2).timeout 
	"""
	when shot call this from ready w await
	play explosion animation
	after return call laser shoot from ready
	"""
	
func laser_shoot():
	$".".play("laser")
	"""
	give velocity
	pull direction from somewhere
	"""

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.health -= bullet_damage
		body.flash()
	
	if body.is_in_group("player") or body.is_in_group("asteroid"):
		queue_free()

func _on_ready():
	await play_explosion_animation()
	laser_shoot()
