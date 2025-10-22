extends Node2D
@onready var player = get_node("%Player")
@onready var player_hitbox = get_node("%Player/")
var heal_amount : int = 4
@export var despawn_time_sec : int = 30


func _ready() -> void:
	self.add_to_group("health_packs",true)
	$despawn_timer.start(despawn_time_sec)


func _process(delta: float) -> void:
	pass

func add_health():
	if (player.get_health() < player.max_health):
		player.adjust_health(-heal_amount)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.healthpack_captured.emit(-heal_amount) # negative bc this is the only time the health goes up
		queue_free()                                     # so the func is built to count down


func _on_despawn_timer_timeout() -> void:
	queue_free()
