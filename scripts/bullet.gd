extends AnimatedSprite2D

const SPEED = 400

@onready var bullet: AnimatedSprite2D = $"."
@onready var player: CharacterBody2D = $Player

@onready var hit = Node2D.new()

func _physics_process(delta):
	position -= transform.y * SPEED * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.is_in_group("mobs"):
	
	$Timer.start()
	hit = body



func _on_timer_timeout() -> void:
	#print(hit)
	#print($Player)
	if hit != player:#hit.get_class() == "CharacterBody2D":
		pass
		#print("ayy")
		#hit.queue_free()
	#queue_free()
