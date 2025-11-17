extends Weapon

@onready var missile_scene = preload("res://scenes/homing_missile.tscn")
@onready var player = get_tree().get_first_node_in_group("player")

func shoot():
	if not weapon_data:
		return
		
	if not can_shoot:
		return
	
	#can_shoot = false
	
	var individual_missile = missile_scene.instantiate()
	individual_missile.global_position = global_position
	individual_missile.global_rotation = player.global_rotation
	individual_missile.target = get_tree().get_nodes_in_group("enemies").pick_random() # TODO check for empty group
	get_tree().get_first_node_in_group("game").add_child(individual_missile)


func create_enemy_tree():
	pass
	
func dwadaw():
	pass

func select_nearest_enemy():
	pass
