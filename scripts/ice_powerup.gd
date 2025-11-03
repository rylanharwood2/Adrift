extends AnimatedSprite2D

@onready var player = get_node("%Player")
@export var despawn_time_sec : int = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$despawn_timer.start(despawn_time_sec)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# I added an area2d as a hitbox for player detection
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
	#player.activate_ice_powerup()
		SignalBus.applied_ice.emit()
		queue_free()
		


func _on_despawn_timer_timeout() -> void:
	queue_free()
	print(get_tree().get_node_count_in_group("asteroid"))
	print(get_tree().get_node_count_in_group("ice_powerups"))
