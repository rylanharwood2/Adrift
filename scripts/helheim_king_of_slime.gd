@icon("res://assets/sprites/enemies/testboss2.png")
extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")

var health = 8


const MOVE_SPEED : int = 750
const SPIN_SPEED : int = 300
#@onready var target = get_tree().current_scene.get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	var direction = (player.position-position).normalized()
	#if (player.distance_to() < 50):    # if close attack and slow
	#	print("si")						# if far idle/move and 2.5x? speed
	# if you wanna be really cool start a timer as long as the player is not 
	# within a raduius and only if they leave it for x time he switches to 
	# move mode or vice versa
	velocity = direction * MOVE_SPEED * delta
	
	move_and_slide()

func play_death():
	queue_free()


func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.8)
	$flash_timer.start()

func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)
