extends AnimatedSprite2D

signal applied_ice
@onready var player = get_node("%Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func 
#applied_ice
#enemy.apply_slow(slow_factor, duration)

# I added an area2d as a hitbox for player detection
func _on_area_2d_body_entered(body: Node2D) -> void:
	#player.activate_ice_powerup()
	
	queue_free()
