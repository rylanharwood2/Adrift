extends AnimatedSprite2D

@onready var player = get_node("%Player")
@export var despawn_time_sec : int = 10


func _ready() -> void:
	$despawn_timer.start(despawn_time_sec)
	animation = "railgun"#weapon_data.sprite
	print("ice")

func _process(delta: float) -> void:
	pass


@export var weapon_data : WeaponData
func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		body.equip_weapon(weapon_data)
		queue_free()
		

func _on_despawn_timer_timeout() -> void:
	queue_free()
	print(get_tree().get_node_count_in_group("asteroid"))
	print(get_tree().get_node_count_in_group("ice_powerups"))
