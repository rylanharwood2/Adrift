extends Camera2D

@onready var player: CharacterBody2D = $"../Player"
#@onready var enemy: CharacterBody2D = $"../enemy"

@export var random_strength : float = 10.
@export var shake_fade : float = 6.

@export var SPEED = 10

var shake_strength : float = 0.0

func apply_shake():
	shake_strength = random_strength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("activate_forcefield"):
		apply_shake()
		
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		offset = random_offset()
	
	#if player:
	position = lerp(position, player.position, SPEED * delta)
	#else:
	#	position = lerp(position, enemy.position, SPEED*delta)

# camera right : 809
# camera top : -463

func random_offset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
