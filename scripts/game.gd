extends Node2D
var animation: String

var rand = RandomNumberGenerator.new()
# TODO aidan this variable is important, load the powerup at the top of the file so it will be ready when you need it
var enemy_scene = load("res://scenes/suicune_enemy.tscn")

var current_player_health : int = -1
var current_player_ammo : int = -1

func new_game():
	$HUD.show_message("")#Welcome to the \nThunderdome!!")

	#%Player.start($start_position(this is a marker2d).position)
	$enemy_spawn_points/start_timer.start()


func wave_spawner(timeout):
		
	for i in range(0,timeout):
		await get_tree().create_timer(timeout).timeout 
		var enemy = enemy_scene.instantiate()
		rand.randomize()
		var mob_spawn_location = $enemy_spawn_points/suicune_spawn_path/spawn_location
		$enemy_spawn_points/suicune_spawn_path/spawn_location.progress_ratio = randf()
		print("yellow")
		enemy.position = mob_spawn_location.position
		add_child(enemy)

func wave_controller():
	$enemy_spawn_points/spawn_timer.one_shot = true
	
	var waves : int = 5
	var waves_done : bool = false
	var timeout : float = 0
	
	for i in waves:
		timeout = (1/(i+1))
		# why is timeout 0 after first iteration ????
		print(timeout)
		await wave_spawner(timeout)
		
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
