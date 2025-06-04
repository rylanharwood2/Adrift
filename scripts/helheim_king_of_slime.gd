extends CharacterBody2D

signal health_pack_received

const MOVE_SPEED : int = 750
const SPIN_SPEED : int = 300
#@onready var target = get_tree().current_scene.get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_pack_received.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = (%Player.position-position).normalized()
	#if (%Player.distance_to() < 50):    # if close attack and slow
	#	print("si")						# if far idle/move and 2.5x? speed
	# if you wanna be really cool start a timer as long as the player is not 
	# within a raduius and only if they leave it for x time he switches to 
	# move mode or vice versa
	velocity = direction * MOVE_SPEED * delta
	
	
	move_and_slide()
