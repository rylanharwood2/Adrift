extends Camera2D

@onready var player: CharacterBody2D = $"../Player"
#@onready var enemy: CharacterBody2D = $"../enemy"

@export var SPEED = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#if player:
	position = lerp(position, player.position, SPEED * delta)
	#else:
	#	position = lerp(position, enemy.position, SPEED*delta)

# camera right : 809
# camera top : -463
