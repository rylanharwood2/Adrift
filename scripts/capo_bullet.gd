extends "res://scripts/bullet.gd"

var bullet_damage = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.health -= bullet_damage
		body.flash()
	
	if body.is_in_group("player") or body.is_in_group("asteroid"):
		queue_free()
