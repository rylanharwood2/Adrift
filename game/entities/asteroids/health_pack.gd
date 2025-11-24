extends Node2D

@export var despawn_time_sec : int = 30

var heal_amount : int = 4

func _ready() -> void:
	self.add_to_group("health_packs",true)
	$despawn_timer.start(despawn_time_sec)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.healthpack_captured.emit(-heal_amount) # negative bc this is the only time the health goes up
		queue_free()                                     # so the func is built to count down


func _on_despawn_timer_timeout() -> void:
	queue_free()
