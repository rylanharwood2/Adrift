extends AnimatedSprite2D

signal applied_ice
@onready var player = get_node("%Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	for ice_powerup in get_tree().get_nodes_in_group("ice_powerups"):
		ice_powerup.applied_ice.connect(%Player.active_ice_powerup)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# I added an area2d as a hitbox for player detection
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
	#player.activate_ice_powerup()
		SignalBus.applied_ice.emit()
		queue_free()
