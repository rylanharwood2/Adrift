extends Node2D
var animation: String

var rand = RandomNumberGenerator.new()
var suicune_enemy_scene = preload("res://scenes/suicune_enemy.tscn")
var capo_enemy_scene = preload("res://scenes/capo_enemy.tscn")
var helheim_scene = preload("res://scenes/helheim_king_of_slime.tscn")
var asteroid_scene = preload("res://scenes/asteroid.tscn")
var frozen_asteroid_scene = preload("res://scenes/frozen_asteroid.tscn")

var current_player_health : int = -1
var current_player_ammo : int = -1
var has_started_game : bool
@export_group("Wave Timers")
@export var startup_pause_sec : int # init ~5
@export var wave_cooldown_sec : int # init ~2

func _process(_delta: float) -> void:
	pass
	

func _ready() -> void:
	SignalBus.gamestate_changed.connect(_on_state_changed)
	has_started_game = false
	
	new_game()
		
	asteroid_generation()

func _on_state_changed(new_state):
	await get_tree().create_timer(startup_pause_sec).timeout
	if has_started_game == false and GameManager.current_state != GameManager.GameState.MAIN_MENU:
		has_started_game = true
		wave_controller()


func apply_slow():
	print("apply_slow")


func new_game():
	
	$menus/main_menu_ui.display_menu()
	#$menus/HUD.show_message("")#Welcome to the \nThunderdome!!")
	
	# while true: # this has to be a dumb way of doing this     # im leaving this here as a reminder of the time 
	# I hung the game for a day and so to never put while true without using all your braincells
	
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
	var wave_data = load_json("res://data/waves.json")
	if wave_data.is_empty():
		push_error("Wave data is empty!")
		return

	for wave in wave_data["waves"]:
		var wave_number : int = wave["wave"]
		$menus/HUD.show_message("Wave " + str(wave_number))
		
		for subwave in wave["subwaves"]:
			for enemy_data in subwave["enemies"]:
				var enemy_type = enemy_data["type"]
				var count = enemy_data["count"]

				for i in range(count):
					spawn_enemy(enemy_type)
					await get_tree().create_timer(0.3).timeout  # small delay between spawns

			# wait for subwave completion
			while get_tree().get_nodes_in_group("enemies").size() > 0:
				await get_tree().create_timer(wave_cooldown_sec).timeout

		print("Wave", wave_number, "cleared!")
		SignalBus.display_reward_menu.emit()
		await SignalBus.select_upgrade_reward

	print("All waves complete!")
	
	"""
	at start of game floats a single asteroid across the screen leaking green light from within
	once asteroid is destroyed, enemies spill out
	"""


func spawn_enemy(enemy_type: String):
	rand.randomize()

	match enemy_type:
		"suicune":
			var enemy = suicune_enemy_scene.instantiate()
			var spawn_path = $enemy_spawn_points/suicune_spawn_path/spawn_location
			spawn_path.progress_ratio = randf()
			enemy.position = spawn_path.position
			add_child(enemy)

		"capo":
			var enemy = capo_enemy_scene.instantiate()
			var spawn_path = $enemy_spawn_points/suicune_spawn_path/spawn_location
			spawn_path.progress_ratio = randf()
			enemy.position = spawn_path.position
			add_child(enemy)

		"boss", "helheim":
			var enemy = helheim_scene.instantiate()
			enemy.position = Vector2(0, 0)
			add_child(enemy)
			


func healthpack_generation(): # TODO randomly spawn healthpacks around the world every so often - or based on killing enemies or somethin
	pass

func asteroid_generation():
	while get_tree().get_first_node_in_group("boss") == null and $asteroid_cooldown.is_stopped():
		var random_asteroid_cooldown_range = randi_range(7,18)
		var asteroid_quantity = randi_range(1,3) # (inclusive, exclusive)
		
		for i in range(0,asteroid_quantity):
			var asteroid = pick_random_asteroid().instantiate()
			
			add_child(asteroid)
			$asteroid_cooldown.start(random_asteroid_cooldown_range)
	

func pick_random_asteroid() -> PackedScene:
	var asteroid_options = [asteroid_scene, frozen_asteroid_scene]
	var rand_percent = randi_range(1,101)
	var choice = -1
	
	# hard coded yuck
	# but this just creates a 70% chance to spawn a regular asteroid
	# and a 30% chance to spawn a frozen asteroid
	if rand_percent >= 70:
		choice = 1
	elif rand_percent < 70:
		choice = 0
	
	return asteroid_options[choice]

func _on_asteroid_cooldown_timeout() -> void:
	asteroid_generation()
