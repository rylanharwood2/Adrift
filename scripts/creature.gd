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

 
func _ready():
	EnemyDistanceManager.register_enemy(self)

	
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
	if is_in_group("player"):
		return
	EnemyDistanceManager.unregister_enemy(self)
	if is_in_group("boss"):
		queue_free()
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
