extends Area2D

#@onready var player = get_node("%Player")
@export var despawn_time_sec : int = 10


func _ready() -> void:
	$despawn_timer.start(despawn_time_sec)


func _on_despawn_timer_timeout() -> void:
	queue_free()
	print(get_tree().get_node_count_in_group("asteroid"))
	print(get_tree().get_node_count_in_group("ice_powerups"))


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.activate_powerups("ice_powerup")
		queue_free()
