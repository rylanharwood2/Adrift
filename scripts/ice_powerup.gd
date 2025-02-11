extends AnimatedSprite2D

# TODO aidan you should edit the sprite and the size of the collision shape to match


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



# I added an area2d as a hitbox for player detection
func _on_area_2d_body_entered(body: Node2D) -> void:
	# this function is called when a body enters
	print("moan")
