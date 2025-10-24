class_name Asteroid
extends StaticBody2D

@export var speed: float = 150.0
@export var rotation_speed_range: Vector2 = Vector2(-3.0, 3.0) # radians/sec
@export var despawn_margin: float = 400.0  # how far offscreen before despawning
@export var healthpack_drop_threshold_percent : int = 20 # percentage of the time that it spawns

var velocity: Vector2
var rotation_speed: float
var loot_scene = preload("res://scenes/health_pack.tscn")
#var frozen_asteroid_scene = preload("res://scenes/ice_powerup.tscn")
var droppable = null
var drop_chance = randi_range(1,101)
var asteroid_type = "gray_asteroid"

func _ready() -> void:
	randomize()
	
	# Get the viewport size and half-size (world is centered at 0,0)
	var screen_size = get_viewport_rect().size
	var half_size = screen_size / 2

	# Spawn asteroid at random edge
	var start_pos = _get_random_edge_point(half_size, despawn_margin)
	var end_pos = _get_random_edge_point(half_size, despawn_margin)

	# Ensure it travels a decent distance across the screen
	while start_pos.distance_to(end_pos) < half_size.length():
		end_pos = _get_random_edge_point(half_size, despawn_margin)

	position = start_pos

	velocity = (end_pos - start_pos).normalized() * speed

	rotation_speed = randf_range(rotation_speed_range.x, rotation_speed_range.y)

	
	

func _process(delta):
	
	position += velocity * delta
	rotation += rotation_speed * delta

	# Despawn after moving outside an extended rectangle around the viewport
	var screen_size = get_viewport_rect().size
	var half_size = screen_size / 2

	var despawn_rect = Rect2(
		-half_size - Vector2(despawn_margin, despawn_margin),
		screen_size + Vector2(despawn_margin * 2, despawn_margin * 2)
	)

	if not despawn_rect.has_point(position):
		queue_free()
		
	
	if droppable != null:
		droppable.global_transform = global_transform
		#print(droppable)


func _get_random_edge_point(half_size: Vector2, margin: float) -> Vector2:
	var side = randi_range(0, 3)
	match side:
		0: return Vector2(randf_range(-half_size.x, half_size.x), -half_size.y - margin)  # top
		1: return Vector2(randf_range(-half_size.x, half_size.x), half_size.y + margin)   # bottom
		2: return Vector2(-half_size.x - margin, randf_range(-half_size.y, half_size.y)) # left
		3: return Vector2(half_size.x + margin, randf_range(-half_size.y, half_size.y))  # right
	return Vector2.ZERO
	

func play_death() -> void:
	$AnimatedSprite2D.play("death")
	#$CollisionShape2D.disabled = true    # Does not work
	$CollisionShape2D.set_deferred("disabled", true) # Works
	drop_loot()
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		
		queue_free()


func _on_asteroid_collision_detector_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("asteroid"):
		play_death()

func drop_loot():
	# TODO frozen no drops
	#var chosen_loot = choose_loot()
	print("trying to spawn")
	if drop_chance > healthpack_drop_threshold_percent:
		return
	
	droppable = loot_scene.instantiate()#chosen_loot.instantiate()
	
	get_tree().get_first_node_in_group("game").add_child(droppable)


#func choose_loot() -> PackedScene:
	#match asteroid_type:
		#"frozen_asteroid":
			#return frozen_asteroid_scene
		#"gray_asteroid":
			#return healthpack_scene
	#return null
