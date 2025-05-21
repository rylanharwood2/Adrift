extends Node2D
var animation: String

var rand = RandomNumberGenerator.new()
# TODO aidan this variable is important, load the powerup at the top of the file so it will be ready when you need it
var suicune_enemy_scene = load("res://scenes/suicune_enemy.tscn")
var capo_enemy_scene = load("res://scenes/capo_enemy.tscn")

var current_player_health : int = -1
var current_player_ammo : int = -1

func new_game():
	$HUD.show_message("")#Welcome to the \nThunderdome!!")

	#%Player.start($start_position(this is a marker2d).position)
	$enemy_spawn_points/start_timer.start()


func wave_spawner(waves, wave_spawn_rates):
	
	for sub_wave in range(0, wave_spawn_rates[0]):
			
		# somehow connect to Bullets enemy killed signal and check for all enemies dead
		rand.randomize()
		for individual_enemy in range(0, wave_spawn_rates[1] + wave_spawn_rates[2]):
			if wave_spawn_rates[1] > 0:
				wave_spawn_rates[1] -= 1
				var suicune_enemy = suicune_enemy_scene.instantiate()
				
				var mob_spawn_location = $enemy_spawn_points/suicune_spawn_path/spawn_location
				$enemy_spawn_points/suicune_spawn_path/spawn_location.progress_ratio = randf()
				
				suicune_enemy.position = mob_spawn_location.position
				add_child(suicune_enemy)
				
			elif wave_spawn_rates[2] > 0:
				wave_spawn_rates[2] -= 1
				var capo_enemy = capo_enemy_scene.instantiate()
				
				var mob_spawn_location = $enemy_spawn_points/suicune_spawn_path/spawn_location
				$enemy_spawn_points/suicune_spawn_path/spawn_location.progress_ratio = randf()
				
				capo_enemy.position = mob_spawn_location.position
				add_child(capo_enemy)
	
	while true:
		if get_tree().get_first_node_in_group("enemies") != null:
			await get_tree().create_timer(2).timeout 
		else:
			break

func wave_controller():
	$enemy_spawn_points/spawn_timer.one_shot = true
	
	var wave_spawn_rates = [[1,3,0], [1,4,0], [1,5,0], [1,100,0]]
	var waves : int = len(wave_spawn_rates)
	var waves_done : bool = false
	var timeout : float = 0
	
	#[[waves, numsuicune, numcapos],[waves+1, numsuicune+1, numcapos]]
	
	for i in waves:
		var wave_message = str("Wave ",i+1)
		$HUD.show_message(wave_message)
		
		await wave_spawner(waves, wave_spawn_rates[i])
		
	"""
	main idea
	
	once first asteroid is destroyed and enemies spill out
	some logic in main? for when to start the waves
	
	for i in waves:
		print "Wave X"
		spawn Y enemies suicune & Z enemies capo
		
	couple options:
			timer
			kill all enemies
			kill some percentage
			
	when said option is complete increment i
	
	maintain waves_done boolean until boss starts
	signal?
	
	"""



"""
func _on_start_timer_timeout() -> void:
	for i in range(0,25):
		$enemy_spawn_points/spawn_timer.start()
		await get_tree().create_timer(2).timeout 


func _on_timer_timeout() -> void:
	# TODO aidan this section creates an enemy then picks a spawn location then adds them to the overall scene
	# youre gonna use some of this idea 
	var enemy = enemy_scene.instantiate()
	rand.randomize()
	var mob_spawn_location = $enemy_spawn_points/suicune_spawn_path/spawn_location
	$enemy_spawn_points/suicune_spawn_path/spawn_location.progress_ratio = randf()

	enemy.position = mob_spawn_location.position
	add_child(enemy)
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	wave_controller()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if %Player.health != current_player_health:
		current_player_health = %Player.health
		$HUD.update_health(%Player.health)
	if %Player.ammo != current_player_ammo:
		current_player_ammo = %Player.ammo
		$HUD.update_ammo(%Player.ammo)
	$HUD.update_boost_meter()


func _on_player_dead() -> void:
	$enemy_spawn_points/spawn_timer.stop()

func add_new_child(child_to_add,animation):
	add_child(child_to_add)
	child_to_add.play(animation)
