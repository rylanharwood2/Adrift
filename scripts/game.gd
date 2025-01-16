extends Node2D

var rand = RandomNumberGenerator.new()
var enemy_scene = load("res://scenes/suicune_enemy.tscn")

var current_player_health : int = -1
var current_player_ammo : int = -1

func new_game():
	$HUD.show_message("")#Welcome to the \nThunderdome!!")

	#%Player.start($start_position(this is a marker2d).position)
	$enemy_spawn_points/start_timer.start()


func wave_spawner():
	# TODO apparently decide if I want to use wave spawner or a timer
	$enemy_spawn_points/spawn_timer.one_shot = true
	for i in range(0,20):
		await get_tree().create_timer(2).timeout 
		var enemy = enemy_scene.instantiate()
		rand.randomize()
		var possible_locations = [$enemy_spawn_points/spawn1, $enemy_spawn_points/spawn2, $enemy_spawn_points/spawn3, $enemy_spawn_points/spawn4]
		enemy.position = possible_locations[rand.randf_range(0,3)].position
		add_child(enemy)

func _on_start_timer_timeout() -> void:
	for i in range(0,25):
		$enemy_spawn_points/spawn_timer.start()
		await get_tree().create_timer(2).timeout 
		
func _on_timer_timeout() -> void:
	
	var enemy = enemy_scene.instantiate()
	rand.randomize()
	var mob_spawn_location = $enemy_spawn_points/suicune_spawn_path/spawn_location
	$enemy_spawn_points/suicune_spawn_path/spawn_location.progress_ratio = randf()

	enemy.position = mob_spawn_location.position
	add_child(enemy)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	#wave_spawner()

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
