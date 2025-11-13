class_name Creature
extends CharacterBody2D

# Base class for the Player and all Enemies
# incl suicunes, capos, and Helheim

@export var health : int
var max_health : int = 1000#health
var speed_mod : float = 1.0
var dead = false
var icey = false
var offset : Vector2 = Vector2.ZERO
var retreat_direction = null


#var player_node = null

 
func _ready():
	SignalBus.mine_boom.connect(set_retreat_direction)
	choose_ai_behavior()
	
# getters
func get_health() -> int:
	return health


# flash on damage received
func flash():
	$ship.material.set_shader_parameter("flash_modifier", 0.8)
	$flash_timer.start()

func _on_flash_timer_timeout() -> void:
	$ship.material.set_shader_parameter("flash_modifier", 0)


# shader freeze effect (powerup)
func turn_blue():
	$ship.material.set_shader_parameter("blue", true)
	$ice_timer.start()
	speed_mod = 0.5

func _on_ice_timer_timeout() -> void:
	speed_mod = 1.0
	$ship.material.set_shader_parameter("blue", false)


# takin damage


func adjust_health(health_modifier) -> int:
	health -= health_modifier
	health = clampi(health, 0, max_health)
	if health_modifier > 0:
		flash()
	if health <= 0:
		play_death()
	return health

# dyin
func play_death():
	dead = true
	$ship.play("death")
	velocity = Vector2(0,0)
	if is_in_group("player") or is_in_group("boss"):
		return
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)


# New enemy AI
enum EnemyAiOptions {
	ATTACK,
	DASH,
	MOVE,
	RETREAT,
	IDLE
}

var current_state : EnemyAiOptions = EnemyAiOptions.MOVE

func _change_state(new_state : EnemyAiOptions):
	current_state = new_state

func choose_random_behavior():
	pass
	#_change_state(EnemyAiOptions.)

func choose_ai_behavior():
	offset = Vector2.ZERO
	retreat_direction = null
	#await get_tree().create_timer(randi_range(2,5)).timeout
	match current_state:
		EnemyAiOptions.MOVE:
			move()
		EnemyAiOptions.RETREAT:
			retreat()
		EnemyAiOptions.DASH:
			dash()
		EnemyAiOptions.ATTACK:
			attack()
		EnemyAiOptions.IDLE:
			idle()
	

func move():
	"""
	both just drift towards the player after picking a random point 
	in a circle around the player. 
	adjust the radius of attack mode and move mode based on num enemies
	with area2d entered exited
	"""
	var angle = randf() * TAU
	offset = Vector2(cos(angle), sin(angle)) * 125
	
	
	

func retreat():
	
	"""
	maybe still pick a point and then move directly opposite?
	also make this more likely when watching a friend die?
	or more likely after watching a mine blow up
	they could get smart if they were within LOS of a mine when exploded
	"""

func set_retreat_direction(pos):
	retreat_direction = -(pos - global_position).normalized()
	var retreat_timer = get_tree().create_timer(4)
	retreat_timer.timeout.connect(_on_retreat_timer_timeout)

func _on_retreat_timer_timeout():
	retreat_direction = null


func attack():
	pass
	"""
	if within the ring suicunes should move towards and attack the player
	capos should pick a larger ring than suicunes and not move closer when theyre in it
	unless the player shoots at them at which point they may move? who knows man
	"""

func dash():
	"""
	call move and set the speed high? maybe a unique animation
	charge up - then dash
	maybe the father they are from you the longer the dash
	"""
	speed_mod = 6.
	var dash_timer = get_tree().create_timer(1)
	dash_timer.timeout.connect(_on_dash_timer_timeout)


func _on_dash_timer_timeout():
	speed_mod = 1.


func idle():
	pass
	"""
	move in a small path? maybe in a circle or random points 
	in a lil box or somethin
	maybe a little idle animation?
	"""
