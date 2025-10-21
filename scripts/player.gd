extends Creature
#extends CharacterBody2D


signal healthpack_captured
signal health_changed(new_health)
signal ammo_changed(new_ammo)
signal boost_changed(new_boost)

#@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var forcefield = $forcefield

# TODO universal random number seed?
var rng = RandomNumberGenerator.new()

#@export var health: int = 8
@export var max_health: int = 50
@export var ammo_cap: int = 10
@export var ammo: int = 10

@export var flame_on_counter : int = 0
@export var idle_couter : int = 0

@export var acceleration: float = 9.0  	## Acceleration while pressing forward
@export var max_speed: float = 200.0      	## Maximum speed the spaceship can reach
@export var friction: float = 0.982        	## Friction for gradual slowdown
@export var rotation_speed: float = 2    	## Rotation speed when pressing a side input
@export var boost_meter: float = 100.0


const SPEED = 8000.0

var boost_acceleration = acceleration * 2.5
var bullet_type = ""
var holding_direction = ""
var is_colliding: bool = false
var is_tilting: bool = false
var is_boosting: bool = false
var is_boost_recharging: bool = true
var rotation_direction = 0
var last_health: int = -1
var last_ammo: int = -1
var last_boost: int = -1
var just_hit = false
var iced_up = false
var forcefield_active = false

var player_bullet_scene = preload("res://scenes/player_bullet.tscn")
var proxy_mine_scene = preload("res://scenes/proxy_mine.tscn")
@onready var game_world := get_tree().root.get_node("Game")

func _ready() -> void:
	#super()
	$ship.material.set_shader_parameter("flash_modifier", 0)
	$ship_startup.play()
	$invulnerability_frames.start()
	$forcefield.expand(true)
	SignalBus.applied_ice.connect(activate_ice_powerup)
	SignalBus.healthpack_captured.connect(adjust_health)
	


# Control Loop
func _physics_process(delta: float) -> void:
	# TODO  comically this way of using signals is still prolly wrong, the enemy should send a signal 
	# that tells us to update the player health only on a collision instead of running this check every frame
	if dead:
		return
	
	if health > 0:
		update_health_changed(health) 
		update_ammo_changed(ammo)
		update_boost_changed(boost_meter)
	else:
		play_death()
	
	var forward_input = Input.is_action_pressed("move_up")
	var boost_input = Input.is_action_pressed("boost")
	var directional_input = Input.get_axis("move_left","move_right")
	
	rotation_direction = Vector2(1, 0).rotated(rotation)
	
	check_forcefield()
	
	if forward_input:
		velocity += (rotation_direction * acceleration)
		if (velocity.length() > max_speed):
			velocity = velocity.normalized() * max_speed
	elif !forward_input:
		velocity *= friction
	
	
	if Input.is_action_pressed("boost") and boost_meter > 0:
		is_boost_recharging = false
		$boost_cooldown_timer.start()
		is_boosting = true
		max_speed = 300.0
		boost()
	elif !Input.is_action_pressed("boost"):
		max_speed = 200.0
		is_boosting = false
		if boost_meter < 100 and is_boost_recharging:
			boost_meter += 0.4
	
	if Input.is_action_pressed("drift(ebrake)"):
		rotation_speed = 4
	elif !Input.is_action_pressed("drift(ebrake)"):
		rotation_speed = 2
		
	detect_shoot()
	play_tilting_animation()
	play_flame_amimation()
	determine_rotation(directional_input)
	move_and_slide()

func play_death():
	super()
	update_health_changed(0)
	SignalBus.player_died.emit("You Died!\nPress R to Restart", true)

## Weapon Mechanics
func shoot(_bullet_typey):
	var bullet = player_bullet_scene.instantiate()
	bullet.speed *= 2
	if iced_up:
		bullet.icey = true
	$shoot_sound.set_pitch_scale(rng.randf_range(0.95, 1.25))
	$shoot_sound.play()
	owner.add_child(bullet)
	bullet.transform = $muzzle.global_transform
	if iced_up:
		bullet.play("frozen")
	ammo -= 1
	
func detect_shoot():
	if Input.is_action_just_pressed("shoot"):
		if (ammo > 0):
			shoot("")
	
	if $reload_timer.is_stopped() and ammo < ammo_cap:
		reload()
	
func reload():
	if ammo < ammo_cap:
		$reload_timer.start()

func _on_reload_timer_timeout() -> void:
	ammo += 1

# powerups
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("activate_proxy_mine") and $proxy_mine_cooldown.is_stopped():
		var proxy_mine = proxy_mine_scene.instantiate()
		proxy_mine.position = position
		
		game_world.add_child(proxy_mine) # TODO this needs a cooldown and also too much visual clutter
		$proxy_mine_cooldown.start(10)
		

func check_forcefield():
	if Input.is_action_just_pressed("activate_forcefield") and $forcefield_cooldown.is_stopped():
		$forcefield_invul_timer.start(forcefield.expand(false))
		forcefield_active = true
	

func _on_forcefield_invul_timer_timeout() -> void:
	$forcefield_cooldown.start(2)
	forcefield_active = false


func _on_ice_timer_timeout() -> void:
	iced_up = false

# boooooooooost
func boost() -> void:
	#print("modulating")
	# TODO figure out how modulate works lol $ship.modulate = Color(0.5, 0.5, 1.0, 1.0)
	if boost_meter > 0:
		velocity += (rotation_direction * boost_acceleration)
		boost_meter -= 0.4
	if (velocity.length() > max_speed):
		velocity = velocity.normalized() * max_speed
	
func _on_boost_cooldown_timer_timeout() -> void:
	is_boost_recharging = true

func determine_rotation(directional_input) -> void:
	if directional_input == -1:
		rotation_degrees -= rotation_speed
	if directional_input == 1:
		rotation_degrees += rotation_speed
	
# TODO small logic error bug here, the ice powerup wont activate the idle animation if the player is
# holding turn so they can pick up the ice powerup but it wont turn them blue until they stop turning
func play_tilting_animation() -> void:
	var tilting_direction = Input.get_axis("move_left", "move_right")
	if tilting_direction == 1 and !is_tilting:
		if iced_up:
			$ship.play("ice_tilt_right")
		else:
			$ship.play("tilt_right")
		is_tilting = true
	elif tilting_direction == -1 and !is_tilting:
		if iced_up:
			$ship.play("ice_tilt_left")
		else:
			$ship.play("tilt_left")
		is_tilting = true
	if tilting_direction == 0:
		if iced_up:
			$ship.play("ice_idle")
		else:
			$ship.play("idle")
		is_tilting = false

func play_flame_amimation() -> void:
	# TODO make flame_on_counter / idle_counter into one variable
	var flame_on = Input.is_action_pressed("move_up") or (Input.is_action_pressed("boost") and boost_meter > 0) # FLAME ON!
	if flame_on and flame_on_counter == 0:
		$flame_on.play("flame_on")
		flame_on_counter += 1
		idle_couter = 0
	if !flame_on and idle_couter == 0:
		$flame_on.play("idle")
		flame_on_counter = 0
		idle_couter += 1


func hurt_player(dmg : int):
	if not forcefield_active:
		flash() # maybe remove?
		adjust_health(dmg)
	

func activate_ice_powerup() -> void:
	iced_up = true

# theres prob a better way of doing this but these set up the signal to change the HUD
func update_health_changed(updated_health):
	if last_health != updated_health:
		last_health = updated_health
		SignalBus.health_changed.emit(updated_health)


func update_ammo_changed(updated_ammo):
	if last_ammo != updated_ammo:
		last_ammo = updated_ammo
		SignalBus.ammo_changed.emit(updated_ammo)

func update_boost_changed(updated_boost):
	if last_boost != updated_boost:
		last_boost = updated_boost
		SignalBus.boost_changed.emit(updated_boost)

func change_health(change_amount):
	health += clamp(change_amount, 0, max_health)

func _on_player_died(nothing, also_nothing) -> void: # the player died signal is dumb the way I did it, its used in main with HUD to display the message
	dead = true
	
func _process(val: float) -> void:
	if dead:
		if Input.is_action_pressed("restart"):
			get_tree().change_scene_to_file("res://scenes/game.tscn")



	
