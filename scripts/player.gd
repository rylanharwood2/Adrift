extends CharacterBody2D

signal player_died(message, bool)
signal healthpack_captured
signal health_changed(new_health)
signal ammo_changed(new_ammo)
signal boost_changed(new_boost)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var forcefield = $forcefield

# TODO universal random number seed?
var rng = RandomNumberGenerator.new()

@export var health: int = 8
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
var dead = false
var iced_up = false
var can_die = true

var scene = preload("res://scenes/player_bullet.tscn")


func _ready() -> void:
	$ship_startup.play()
	$invulnerability_frames.start()
	$forcefield.expand(true)
	$ship.material.set_shader_parameter("flash_modifier", 0)


# Control Loop
func _physics_process(delta: float) -> void:
	# TODO  comically this way of using signals is still prolly wrong, the enemy should send a signal 
	# that tells us to update the player health only on a collision instead of running this check every frame
	if health > 0:
		update_health_changed(health) 
		update_ammo_changed(ammo)
		update_boost_changed(boost_meter)
	else:
		update_health_changed(0)
		if health <= 0:
			player_died.emit("You Died!\nPress R to Restart", true)
			dead = true
	
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
	
	if health > 0:
		detect_shoot()
		play_tilting_animation()
		play_flame_amimation()
		determine_rotation(directional_input)
		move_and_slide()


## Weapon Mechanics
func shoot(_bullet_typey):
	var bullet = scene.instantiate()
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


# flash on damage received
func flash():
	$ship.material.set_shader_parameter("flash_modifier", 0.8)
	$flash_timer.start()

func _on_flash_timer_timeout() -> void:
	$ship.material.set_shader_parameter("flash_modifier", 0)


# boooooooooost
func boost() -> void:
	print("modulating")
	$ship.modulate = Color(0.5, 0.5, 1.0, 1.0)
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


# detect collisions
func _on_enemy_detector_body_entered(body: Node2D) -> void:
	# TODO allow them to hit you again if they are still attached
	if ($invulnerability_frames.is_stopped() and body.is_in_group("enemies")):
		hurt_player()
		
	if (body.is_in_group("healthpack")):
		healthpack_captured.emit()
			
		#is_colliding = true
	
func _on_enemy_detector_body_exited(body: Node2D) -> void:
	just_hit = false
	
func _on_enemy_hit_cooldown_timeout() -> void:
	if (just_hit):
		hurt_player()
		
func hurt_player():
	if can_die:
		$invulnerability_frames.start()
		$player_hurt.play()
		flash()
		health -= 1
		$enemy_hit_cooldown.start()
		just_hit = true
		

func active_ice_powerup() -> void:
	iced_up = true

# theres prob a better way of doing this but these set up the signal to change the HUD
func update_health_changed(updated_health):
	if updated_health >= last_health or can_die:# edit for forcefield invul
		if last_health != updated_health:
			last_health = updated_health
			health_changed.emit(updated_health)


func update_ammo_changed(updated_ammo):
	if last_ammo != updated_ammo:
		last_ammo = updated_ammo
		ammo_changed.emit(updated_ammo)

func update_boost_changed(updated_boost):
	if last_boost != updated_boost:
		last_boost = updated_boost
		boost_changed.emit(updated_boost)

func change_health(change_amount):
	health += clamp(change_amount, 0, max_health)

func _on_player_died() -> void:
	dead = true
	
func _process(val: float) -> void:
	if dead:
		if Input.is_action_pressed("restart"):
			get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ice_timer_timeout() -> void:
	iced_up = false
	

func check_forcefield():
	if Input.is_action_just_pressed("activate_forcefield") and $forcefield_cooldown.is_stopped():
		$forcefield_invul_timer.start(forcefield.expand(false))
		can_die = false
	

func _on_forcefield_invul_timer_timeout() -> void:
	$forcefield_cooldown.start(2)
	can_die = true
