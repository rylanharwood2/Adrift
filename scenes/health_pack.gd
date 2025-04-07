extends Node2D
@onready var player = get_node("%Player")
@onready var player_hitbox = get_node("%Player/")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_to_group("healthpack",true)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	player_detection()
	#queue_free()

func add_health():
	if (player.health < player.max_health):
		player.health += 5

func player_detection():
	pass
	#player.connect("healthpack_captured", self, "add_health")#"pressed", self, "_start_game")
	
	
	
