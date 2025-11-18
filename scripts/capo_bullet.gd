extends Bullet

var bullet_damage: int = 1
var speed_mod: float = 1.0

signal fire_animation_done

func _ready() -> void:
	speed = 0
	animation_finished.connect(_on_animation_finished)
	play("fire")

#func play_fire_animation() -> void:
	#play("fire")  # play the fire/charge-up animation

func _on_animation_finished() -> void:
	if animation == "fire":
		fire_animation_done.emit()
		laser_shoot()

func laser_shoot() -> void:
	speed = 500 * speed_mod
	play("laser")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hurt_player(1)
	if body.is_in_group("player") or body.is_in_group("asteroid"):
		queue_free()
