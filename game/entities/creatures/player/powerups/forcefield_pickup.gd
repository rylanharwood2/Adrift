extends Area2D

#@onready var player = get_node("%Player")
@export var despawn_time_sec : int = 10


func _ready() -> void:
	$despawn_timer.start(despawn_time_sec)


func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
