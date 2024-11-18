extends Node2D

var rand = RandomNumberGenerator.new()
var enemy_scene = load("res://scenes/suicune_enemy.tscn")

var current_player_health : int = -1
var current_player_ammo : int = -1

func new_game():
	$HUD.show_message("")#Welcome to the \nThunderdome!!")
	
	

func wave_spawner():
	$enemy_spawn_points/spawn_timer.one_shot = true
	for i in range(0,10):
		await get_tree().create_timer(2).timeout 
		var enemy = enemy_scene.instantiate()
		rand.randomize()
		var possible_locations = [$enemy_spawn_points/spawn1, $enemy_spawn_points/spawn2, $enemy_spawn_points/spawn3, $enemy_spawn_points/spawn4]
		enemy.position = possible_locations[rand.randf_range(0,3)].position
		add_child(enemy)

		
		
		
func _on_timer_timeout() -> void:
	
	var enemy = enemy_scene.instantiate()
	rand.randomize()
	var possible_locations = [$enemy_spawn_points/spawn1, $enemy_spawn_points/spawn2, $enemy_spawn_points/spawn3, $enemy_spawn_points/spawn4]
	print(rand.randi_range(0,3))
	enemy.position = possible_locations[rand.randi_range(0,3)].position
	add_child(enemy)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	wave_spawner()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if %Player.health != current_player_health:
		current_player_health = %Player.health
		$HUD.update_health(%Player.health)
	if %Player.ammo != current_player_ammo:
		current_player_ammo = %Player.ammo
		$HUD.update_ammo(%Player.ammo)
	$HUD.update_boost_meter()
	
	# maybe add a velocity/speed element to the hud for debugging
		
