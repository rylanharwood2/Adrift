extends Area2D

enum MineState {SPAWNING, ARMING, ARMED, TRIGGERED, DEAD}
var current_state : MineState = MineState.SPAWNING

@export var arming_delay : float = 2
@export var explosion_damage : int = 2
@export var explosion_radius : int = 125
var draw_size : float = 0
@export var lifetime_after_armed : float = 25.
var should_rotate : bool = false

var who_boom : Node2D

func _ready():
	
	show()
	change_state(MineState.ARMING)

func _process(delta: float) -> void:
	rotate_mine(delta)
	queue_redraw()


# draw the red line animation on mine ARMED
func _draw():
	if current_state == MineState.ARMED:
		if draw_size +1 <= explosion_radius:
			if $drawing_test.is_stopped():
				$drawing_test.start(0.01)
			
			draw_circle(Vector2.ZERO, draw_size, Color.RED, false)
		draw_circle(Vector2.ZERO, draw_size, Color.RED, false)

func _on_drawing_test_timeout() -> void:
	draw_size += 3



func change_state(new_state : MineState):
	current_state = new_state
	match current_state:
		MineState.ARMING:
			$CollisionShape2D.disabled = true
			$sprite.play("not_flashing")
			$arming_timer.start(arming_delay)
		MineState.ARMED:
			$sprite.play("flashing")
			$CollisionShape2D.disabled = false
			$despawn_timer.start(lifetime_after_armed)
		MineState.TRIGGERED:
			SignalBus.mine_boom.emit(global_position)
			explode()
			
		MineState.DEAD:
			queue_free()


func _on_body_entered(_body: Node2D) -> void:
	if current_state != MineState.TRIGGERED:
		change_state(MineState.TRIGGERED)

func rotate_mine(delta : float):
	if should_rotate:
		rotation_degrees += 15 * delta

func explode():
	$sprite.play("explosion")
	rotate_mine(0)
	apply_explosion_damage()
	
	#await get_tree().create_timer(8).timeout# handle explosion countdown (0.3 sec?)
	#change_state(MineState.DEAD)


func apply_explosion_damage():
	var space_state = get_world_2d().direct_space_state

	# Create query parameters
	var params := PhysicsShapeQueryParameters2D.new()
	var shape := CircleShape2D.new()
	shape.radius = explosion_radius

	params.shape = shape
	params.transform = global_transform

	# Query overlapping bodies
	for res in space_state.intersect_shape(params, 64):
		var obj = res.collider
		if obj:
			if obj.is_in_group("player"):
				obj.hurt_player(explosion_damage)
			elif obj.has_method("adjust_health"):
				obj.adjust_health(explosion_damage)
			elif obj.is_in_group("asteroid"):
				obj.play_death()




func _on_arming_timer_timeout() -> void:
	if current_state == MineState.ARMING:
		change_state(MineState.ARMED)


func _on_despawn_timer_timeout() -> void:
	if current_state == MineState.ARMED:
		change_state(MineState.DEAD)


func _on_sprite_animation_finished() -> void:
	if $sprite.animation == "explosion":
		change_state(MineState.DEAD)
