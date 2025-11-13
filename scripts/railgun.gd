extends Weapon

@onready var beam = $railgun_beam

func _ready() -> void:
	super()
	beam.scale.y = 10
	beam.visible = false
	beam.modulate.a = 0.0
	
	#position += Vector2(30,0)
 
func shoot():
	if not weapon_data:
		return
		
	if not can_shoot:
		return
	
	can_shoot = false
	$railgun_shoot_sound.play()
	fade_in_and_out()
	SignalBus.applied_recoil.emit(20.)


func fade_in_and_out():
	$CollisionShape2D.disabled = false
	
	can_shoot = false
	beam.visible = true
	beam.modulate.a = 1.0
	
	var tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(beam, "modulate:a", 0.0, 1.).set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(func(): 
		beam.visible = false
		$CollisionShape2D.disabled = true
		apply_durability()
		await get_tree().create_timer(weapon_data.shoot_cooldown).timeout
		can_shoot = true
	)
	


# deal damage
func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("enemies"):
		body.adjust_health(2)
	if body.is_in_group("asteroid"):
		body.play_death()
