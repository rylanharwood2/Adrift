extends Asteroid

func _ready():
	super()
	healthpack_drop_percentage = 0.34
	weapon_drop_percentage = 0.67
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		queue_free()
