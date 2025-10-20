extends Creature


var scene = preload("res://scenes/bullet.tscn")

@onready var target = get_tree().current_scene.get_node("Player")

var rand = RandomNumberGenerator.new()

var  speed = randf_range(3500.0, 4500.0)
const TURN_SPEED = 2.0 # max turn speed (idk units)
# var health = 2

var targgg = Vector2(0,0)
var target_angle = Vector2(0,0)


func _process(delta: float) -> void:
	var direction = Vector2(cos(rotation), sin(rotation))
	if dead:
		return
	
	targgg = target.position
	target_angle = (targgg - position).angle()

	# limit rotation speed
	rotation = lerp_angle(rotation, target_angle, TURN_SPEED * delta * speed_mod)

	# move in dir the enemy is facing

	velocity = direction * speed * delta * speed_mod

	move_and_slide()

 
func _ready() -> void:
	pass
	#$ProgressBar.value = health


func _on_ship_animation_finished() -> void:
	if $ship.animation == "death":
		queue_free()
