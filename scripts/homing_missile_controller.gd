extends Weapon

@onready var missile_scene = preload("res://scenes/homing_missile.tscn")

func shoot():
	if not weapon_data:
		return
		
	if not can_shoot:
		return
	
	can_shoot = false
	
	var individual_missile = missile_scene.instantiate()
	
	get_tree().get_first_node_in_group("game").add_child(individual_missile)
