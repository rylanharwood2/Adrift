extends StaticBody2D
var frozen_asteroid_scene = load("res://scenes/ice_powerup.tscn")

@onready var game: Node2D = $"../.."


func play_death() -> void:
	$AnimatedSprite2D.play("death")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		var ice_powerup_location = position 
		print(position)
		
		var ice_powerup = frozen_asteroid_scene.instantiate() 
		
		ice_powerup.position = ice_powerup_location
			
		game.add_child(ice_powerup)
		
		queue_free()
		
		# you will need that command again to get rid of the powerup when the player flies over it
		# TODO ok aidan lets do this, im literally making this up as I go so pls bear with and shoot me any questions
		# you are likely going to need to look in the godot docs / forums for help
		# firstly spawn in a ice powerup, you will prolly need the asteroid position, you can prolly use position as seen below
		# you can prolly look at the wave spawner making enemies in TODO to see how I spawn instances of scenes
