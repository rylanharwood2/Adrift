extends Node2D
var animation: String

var rand = RandomNumberGenerator.new()
var suicune_enemy_scene = load("res://scenes/suicune_enemy.tscn")
var capo_enemy_scene = load("res://scenes/capo_enemy.tscn")
var helheim_scene = load("res://scenes/helheim_king_of_slime.tscn")

var current_player_health : int = -1
var current_player_ammo : int = -1


func _ready() -> void:
	print("ready")
	#await get_tree().create_timer(0.2).timeout
	new_game()
	
	
	#self.applied_ice.connect(self.apply_slow)
	
	for health_pack in get_tree().get_nodes_in_group("health_packs"):
		health_pack.health_pack_entered.connect(%Player.change_health)

func apply_slow():
	print("apply_slow")

func _process(_delta: float) -> void:
	for ice_powerup in get_tree().get_nodes_in_group("ice_powerups"):
		ice_powerup.applied_ice.connect(%Player.active_ice_powerup)
	
# TODO signal bus
func new_game():
	
	$menus/main_menu_ui.display_menu()
	#$menus/HUD.show_message("")#Welcome to the \nThunderdome!!")
	print("new game")
	# TODO somehow wave_controller is getting looped through twice, spawning twice the enemies as asked for
	wave_controller()
	
	%Player.health_changed.connect($menus/HUD.update_health)
	%Player.ammo_changed.connect($menus/HUD.update_ammo)
	%Player.boost_changed.connect($menus/HUD.update_boost_meter)
	%Player.player_died.connect($menus/HUD.show_message)

	$highscore_menu.start_timer(Time.get_ticks_msec())




# Helper function to load and parse the file
func load_json(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open JSON file at " + path)
		return {}
		
	var text = file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(text)
	if result == null:
		push_error("Failed to parse JSON: " + path)
		return {}
	
	return result


# control enemy spawn waves
func wave_controller():
	var wave_message = str("Wave ",1)
	$menus/HUD.show_message(wave_message)
	
	var json_path = "res://data/waves.json"  # adjust path as needed
	var wave_data = load_json(json_path)
	
	# Access example data
	for wave in wave_data["waves"]:
		print("Wave:", wave["wave"])
		for subwave in wave["subwaves"]:
			for enemy in subwave["enemies"]:
				print("  Enemy type:", enemy["type"], "Count:", enemy["count"])
	
	"""
	at start of game floats a single asteroid across the screen leaking green light from within
	once asteroid is destroyed, enemies spill out
	"""

func wave_spawner(waves, wave_spawn_rates):
	
	for sub_wave in range(0, wave_spawn_rates[0]):
		
		rand.randomize()
		for individual_enemy in range(0, wave_spawn_rates[1] + wave_spawn_rates[2] + wave_spawn_rates[3]):
			if wave_spawn_rates[1] > 0: # Spawn Suicunes
				wave_spawn_rates[1] -= 1
				var suicune_enemy = suicune_enemy_scene.instantiate()
				
				var mob_spawn_location = $enemy_spawn_points/suicune_spawn_path/spawn_location
				$enemy_spawn_points/suicune_spawn_path/spawn_location.progress_ratio = randf()
				
				suicune_enemy.position = mob_spawn_location.position
				add_child(suicune_enemy)
				
			elif wave_spawn_rates[2] > 0: # Spawn Capos
				wave_spawn_rates[2] -= 1
				var capo_enemy = capo_enemy_scene.instantiate()
				
				var mob_spawn_location = $enemy_spawn_points/suicune_spawn_path/spawn_location
				$enemy_spawn_points/suicune_spawn_path/spawn_location.progress_ratio = randf()
				
				capo_enemy.position = mob_spawn_location.position
				add_child(capo_enemy)
			
			elif wave_spawn_rates[3] > 0: # Spawn boss
				wave_spawn_rates[3] -= 1
				var helheim = helheim_scene.instantiate()
				
				helheim.position = Vector2(0, 0)
				add_child(helheim)
				print("added")
	
	while true:
		if get_tree().get_first_node_in_group("enemies") != null:
			await get_tree().create_timer(2).timeout 
		else:
			break


func _on_testing_bullet_despawn_timeout() -> void:
	
	for bullet in get_tree().get_nodes_in_group("bullet"):
		pass
		#print(bullet)
	

func healthpack_generation(): # TODO randomly spawn healthpacks around the world every so often - or based on killing enemies or somethin
	pass
