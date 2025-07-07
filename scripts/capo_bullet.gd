extends "res://scripts/bullet.gd"

var bullet_damage = 1
var speed_mod = 1.0

signal fire_animation_done

func _ready():
	$".".speed = 0
	$".".animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished():
	if $".".animation == "fire":
		fire_animation_done.emit()
		laser_shoot()

func play_explosion_animation():
	$".".play("fire")
	"""
	when shot call this from ready w await
	play explosion animation
	after return call laser shoot from ready
	"""
	
func laser_shoot():
	$".".speed = 500 * speed_mod
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
	play_explosion_animation()
