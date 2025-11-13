extends Creature


var scene = preload("res://scenes/bullet.tscn")

@onready var target = get_tree().current_scene.get_node("Player")

var rand = RandomNumberGenerator.new()

var  speed = randf_range(3500.0, 4500.0)
const TURN_SPEED = 2.0 # max turn speed (idk units)
# var health = 2
var player_node = null

var targgg = Vector2(0,0)
var target_angle = Vector2(0,0)




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
		
	rotation = lerp_angle(rotation, target_angle, TURN_SPEED * delta * speed_mod)
	velocity = direction * speed * delta * speed_mod
	choose_ai_behavior()
	move_and_slide()


# enemy on hit damage {
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$ship.play("attack")
		body.hurt_player(1)
		player_node = body
		$hit_cooldown.start(1.0)


func _on_area_2d_body_exited(body: Node2D) -> void:
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
	
