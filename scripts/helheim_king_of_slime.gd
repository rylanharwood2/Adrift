@icon("res://assets/sprites/enemies/testboss2.png")
extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")

var health = 8


const MOVE_SPEED : int = 20000
const SPIN_SPEED : int = 300
const TURN_SPEED : float = 3.0

var speed_mod = 1.0
var player_position = Vector2(0, 0)
var player_angle = Vector2(0, 0)
var move_speed_mod = 0
#@onready var target = get_tree().current_scene.get_node("Player")

var searching = true
var locked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash()
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	add_to_group("boss")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if (player.distance_to() < 50):    # if close attack and slow
	#	print("si")						# if far idle/move and 2.5x? speed
	# if you wanna be really cool start a timer as long as the player is not 
	# within a raduius and only if they leave it for x time he switches to 
	# move mode or vice versa
	var direction = Vector2(cos(rotation), sin(rotation))
	if searching:
		var distance_to_player = (0)
		player_position = player.position
		distance_to_player = self.position.distance_to(player_position)
		player_angle = (player_position - position).angle()
	
		# limit rotation speed
		rotation = lerp_angle(rotation, player_angle, TURN_SPEED * delta * speed_mod)
	if !searching:
		velocity = direction * MOVE_SPEED * delta * speed_mod * move_speed_mod
		begin_charge()
	else:
		velocity = Vector2(0, 0)
	
	if abs(rotation - player_angle) < 0.05:
		searching = false
	
	move_and_slide()

func play_death():
	queue_free()


func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.8)
	$flash_timer.start()

func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)
	
func turn_blue():
	speed_mod = 0.75


func _on_charge_timer_timeout() -> void:
	searching = true

func begin_charge() -> void:
	if !locked:
		$AnimatedSprite2D.play("charging charge attack")
		locked = true
	
func _on_animation_finished():
	if $AnimatedSprite2D.animation == "charging charge attack":
		$AnimatedSprite2D.play("charge attack")
		move_speed_mod = 1
	elif $AnimatedSprite2D.animation == "charge attack":
		move_speed_mod = 0
		searching = true
		locked = false
	else:
		$AnimatedSprite2D.play("default")
