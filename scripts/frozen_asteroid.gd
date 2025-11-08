extends Asteroid

var weapon_drops = [
	preload("res://data/spreader.tres"),
	preload("res://data/homing_launcher.tres"),
	preload("res://data/railgun.tres")
]

func _ready() -> void:
	super()
	loot_scene = load("res://scenes/ice_powerup.tscn")
	asteroid_type = "frozen_asteroid"

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		queue_free()
