extends Creature


var scene = preload("res://scenes/bullet.tscn")

@onready var target = get_tree().current_scene.get_node("Player")

var rand = RandomNumberGenerator.new()

var  speed = randf_range(105.0, 115.0)
const TURN_SPEED = 2.0 # max turn speed (idk units)
# var health = 2
var player_node = null

var targgg = Vector2(0,0)
var target_angle = Vector2(0,0)

func _ready():
	super()
	SignalBus.mine_boom.connect(set_retreat_direction)
	get_tree().create_timer(2.0).timeout.connect(_change_state)


func _process(delta: float) -> void:
	
	if dead:
		return
	
	targgg = target.position
	if global_position.distance_to(target.global_position) > 130:
		targgg = target.position + offset
	
	
	
	target_angle = (targgg - position).angle()

	# limit rotation speed
	

	# move in dir the enemy is facing
	var direction = Vector2(cos(rotation), sin(rotation))
	
	if retreat_direction != null:
		#direction = retreat_direction
		target_angle = retreat_direction.angle()
		
	rotation = lerp_angle(rotation, target_angle, TURN_SPEED * delta)
	velocity = direction * speed * speed_mod
	move_and_slide()


# enemy on hit damage {
func _on_area_2d_body_entered(body: Node2D) -> void:
	if $ship.animation == "dead":
		return
	
	if body.is_in_group("player"):
		$ship.play("attack")
		body.hurt_player(1)
		player_node = body
		$hit_cooldown.start(1.0)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if $ship.animation == "dead":
		return
	
	player_node = null
	if $ship.animation == "attack":
		$ship.animation = "moving"


func _on_hit_cooldown_timeout() -> void:
	if player_node:
		player_node.hurt_player(1)
		$hit_cooldown.start(1.0)
# }

func _on_ship_animation_finished() -> void:
	if $ship.animation == "death":
		queue_free()
	
# New enemy AI
enum EnemyAiOptions {
	DASH,
	MOVE,
	IDLE,
	RETREAT,
	ATTACK
}

var current_state : EnemyAiOptions = EnemyAiOptions.MOVE

func _change_state():
	if $ship.animation == "death":
		return
	var rand_val = randf()
	if rand_val < 0.7:
		current_state = EnemyAiOptions.MOVE
	elif rand_val < 0.9:
		current_state = EnemyAiOptions.DASH
	else:
		current_state = EnemyAiOptions.IDLE
	get_tree().create_timer(2.0).timeout.connect(_change_state)
	#print(current_state)
	choose_ai_behavior()

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
	speed_mod = 1
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
	var dash_timer = get_tree().create_timer(0.3)
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	


func _on_dash_timer_timeout():
	speed_mod = 1.


func idle():
	"""
	move in a small path? maybe in a circle or random points 
	in a lil box or somethin
	maybe a little idle animation?
	"""
	speed_mod = 0
