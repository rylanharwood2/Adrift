extends Node2D
@onready var player = get_node("%Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_free()
	player_detection()

func player_detection():
	if (player.health > player.max_health):
		player.health += 5
	
