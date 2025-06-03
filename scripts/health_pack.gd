extends CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $"."



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 1. dectect if the player is touching the healthpack 
	# 2. if they are, add 4 health
	# 2. remove the health pack from environment 
	 
	queue_free( )
	
