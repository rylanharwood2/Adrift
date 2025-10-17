extends Area2D

enum MineState {SPAWNING, ARMING, ARMED, TRIGGERED, DEAD}
var current_state : MineState = MineState.SPAWNING

@export var arming_delay : float = 2
@export var explosion_damage : int = 2
@export var explosion_radius : int = 5
@export var lifetime_after_armed : float = 100.

var who_boom : Node2D

func _ready():
	change_state(MineState.ARMING)

func _process(float) -> void:
	pass
	#queue_redraw() # delete


func change_state(new_state : MineState):
	current_state = new_state
	match current_state:
		MineState.ARMING:
			$CollisionShape2D.disabled = true
			#$sprite.play("")
			$arming_timer.start(arming_delay)
		MineState.ARMED:
			$sprite.play("flashing")
			$CollisionShape2D.disabled = false
			$despawn_timer.start(lifetime_after_armed)
		MineState.TRIGGERED:
			print("triggered")
			explode()
		MineState.DEAD:
			queue_free()


func _on_body_entered(body: Node2D) -> void:
	change_state(MineState.TRIGGERED)


func explode():
	#$sprite.play("explode")
	print("explode")
	apply_explosion_damage()
	
	await get_tree().create_timer(3).timeout# handle explosion countdown (0.3 sec?)
	change_state(MineState.DEAD)
	
	#if who_boom.is_in_group("enemies"):
		#if who_boom.health == 1:
			#who_boom.play_death()
		#else:
			#who_boom.health -= 1
		#who_boom.flash()
	#if who_boom.is_in_group("asteroid"):
		#who_boom.play_death()
	#change_state(MineState.DEAD)




func apply_explosion_damage():
	print("apply")
	var space_state = get_world_2d().direct_space_state

	# Create query parameters
	var params := PhysicsShapeQueryParameters2D.new()
	var shape := CircleShape2D.new()
	shape.radius = explosion_radius

	params.shape = shape
	params.transform = Transform2D(0, global_position)

	print("hi")
	# Query overlapping bodies
	for res in space_state.intersect_shape(params, 64):
		print("inside")
		var obj = res.collider
		if obj and obj.is_in_group("enemies"):
			#if obj.has_method("hit"):
			#	obj.hit(explosion_damage)
			#obj.health -= explosion_damage
			if "health" in obj:
				print("yep")
				obj.health -= explosion_damage
			if obj.health <= 0 and obj.has_method("play_death"):
				obj.play_death()

func _draw():
	pass
	#draw_circle(Vector2.ZERO, 100, Color.RED)




func _on_arming_timer_timeout() -> void:
	if current_state == MineState.ARMING:
		change_state(MineState.ARMED)


func _on_despawn_timer_timeout() -> void:
	if current_state == MineState.ARMED:
		change_state(MineState.DEAD)
