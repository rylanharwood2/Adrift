@icon("res://assets/sprites/enemies/testboss2.png")
extends Creature

@onready var player = get_tree().get_first_node_in_group("player")

# var health = 8


const MOVE_SPEED : int = 20000
const SPIN_SPEED : int = 300
const TURN_SPEED : float = 3.0

var player_position = Vector2(0, 0)
var player_angle = Vector2(0, 0)
var move_speed_mod = 1
#@onready var target = get_tree().current_scene.get_node("Player")

var searching = true
var locked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ship.animation_finished.connect(_on_animation_finished)
	add_to_group("boss")
	

func move_process(delta: float) -> void:
		#if (player.distance_to() < 50):    # if close attack and slow
	#	print("si")						# if far idle/move and 2.5x? speed
	# if you wanna be really cool start a timer as long as the player is not 
	# within a raduius and only if they leave it for x time he switches to 
	# move mode or vice versa
	if dead:
		return
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * MOVE_SPEED * delta * speed_mod * move_speed_mod
	if searching:
		var distance_to_player = (0)
		player_position = player.position
		distance_to_player = self.position.distance_to(player_position)
		player_angle = (player_position - position).angle()
	
		# limit rotation speed
		rotation = lerp_angle(rotation, player_angle, TURN_SPEED * delta * speed_mod)
	if !searching:
		begin_charge()
	
	if abs(rotation - player_angle) < 0.05:
		searching = false
	
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_process(delta)


func _on_charge_timer_timeout() -> void:
	searching = true

func begin_charge() -> void:
	if !locked:
		$ship.play("charging charge attack")
		locked = true
	
func _on_animation_finished():
	if $ship.animation == "death":
		queue_free()
	elif $ship.animation == "spin charge":
		$ship.play("spin attack")
		for body in $spin_hitbox.get_overlapping_bodies():
			if body.is_in_group("player"):
				body.hurt_player(1)
	elif $ship.animation == "spin attack":
		searching = true
		locked = false
		move_speed_mod = 1
		$ship.play("default")
	elif $ship.animation == "charging charge attack":
		$ship.play("charge attack")
		move_speed_mod = 3
	elif $ship.animation == "charge attack":
		move_speed_mod = 1
		searching = true
		locked = false
	else:
		$ship.play("default")




func _on_spin_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$ship.play("spin charge")
