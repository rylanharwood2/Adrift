extends Area2D
class_name WeaponPickup

@export var weapon_data : WeaponData
@export var despawn_time_sec : int = 15


func _ready() -> void:
	if weapon_data:
		pass#$weapon_sprite.texture = weapon_data.sprite
	#$despawn_timer.start(despawn_time_sec)
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.equip_weapon(weapon_data)
		queue_free()


func _on_despawn_timer_timeout() -> void:
	queue_free()
