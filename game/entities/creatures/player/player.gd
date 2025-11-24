extends Creature


#@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var forcefield = $forcefield

# TODO universal random number seed?
var rng = RandomNumberGenerator.new()

#@export var health: int = 8
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
var can_spin = true
var ice_powerup_duration : int = 15


## Powerups
# powerup enabled flags
var proxy_mine_enabled  : bool = false
var forcefield_enabled  : bool = false
var ice_powerup_enabled : bool = false

var forcefield_active   : bool = false


# weapon system TODO
var current_weapon = null


var player_bullet_scene = preload("res://game/entities/creatures/player/player_bullet.tscn")
var proxy_mine_scene = preload("res://game/entities/creatures/player/powerups/proxy_mine.tscn")
@onready var game_world := get_tree().root.get_node("Game")

func _ready() -> void:
	#super()
	$ship.material.set_shader_parameter("flash_modifier", 0)
	$ship_startup.play()
	$invulnerability_frames.start()
	$forcefield.expand(true)
	SignalBus.healthpack_captured.connect(adjust_health)
	SignalBus.change_max_health.connect(change_max_health)
	SignalBus.add_new_ability.connect(enable_ability)
	SignalBus.weapon_broken.connect(break_weapon)
	SignalBus.railgun_shot.connect(_railgun_shot)
	max_health = health
	


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
	var directional_input = Input.get_axis("move_left","move_right")
	
	rotation_direction = Vector2(1, 0).rotated(rotation)
	
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
	
	if Input.is_action_pressed("drift(ebrake)") and can_spin:
		rotation_speed = 4
	elif !Input.is_action_pressed("drift(ebrake)") and can_spin:
		rotation_speed = 2
		
	detect_shoot()
	play_tilting_animation()
	play_flame_amimation()
	determine_rotation(directional_input)
	move_and_slide()



## Weapon Mechanics
func equip_weapon(data: WeaponData):
	if current_weapon:
		current_weapon.queue_free()
		
	
	var new_weapon = data.weapon_scene.instantiate()
	
	new_weapon.weapon_data = data
	current_weapon = new_weapon
	call_deferred("add_child", new_weapon)
	


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
			if current_weapon == null:
				shoot("")
			else:
				current_weapon.shoot()
			
	
	if $reload_timer.is_stopped() and ammo < ammo_cap:
		reload()
	
func reload():
	if ammo < ammo_cap:
		$reload_timer.start()

func _on_reload_timer_timeout() -> void:
	ammo += 1

func break_weapon():
	if current_weapon:
		current_weapon.queue_free()

func apply_recoil(recoil_strength : float):
	pass
	# TODO this technically works but its not good
	#var recoil_dir = -transform.x.normalized() # opposite of facing direction
	#var recoil_distance = recoil_dir * recoil_strength
	#
	## Apply smooth knockback using a tween
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", position + recoil_distance, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _railgun_shot(time: float):
	can_spin = false
	rotation_speed = 0.4
	await get_tree().create_timer(time).timeout
	rotation_speed = 2
	can_spin = true


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



## Powerups
func enable_ability(ability : String):
	if ability == "proxy_mine":
		proxy_mine_enabled = true
	if ability == "ice_powerup":
		ice_powerup_enabled = true
	if ability == "forcefield":
		forcefield_enabled = true


func _input(event: InputEvent) -> void:
	if dead:
		return
		
	if proxy_mine_enabled and event.is_action_pressed("activate_proxy_mine") and $proxy_mine_cooldown.is_stopped():
		var proxy_mine = proxy_mine_scene.instantiate()
		proxy_mine.position = position
		
		game_world.add_child(proxy_mine)
		$proxy_mine_cooldown.start(10)
		SignalBus.ability_used.emit("proxy_mine")
		
		
	if forcefield_enabled and not forcefield_active and event.is_action_pressed("activate_forcefield") and $forcefield_cooldown.is_stopped():
		$forcefield_invul_timer.start(forcefield.expand(false))
		
		forcefield_active = true
		SignalBus.ability_used.emit("forcefield")
		
		
	if ice_powerup_enabled and event.is_action_pressed("activate_ice_powerup") and $ice_timer.is_stopped():
		activate_ice_powerup()
		SignalBus.ability_used.emit("ice_powerup")
		


func _on_forcefield_invul_timer_timeout() -> void:
	$forcefield_cooldown.start(3)
	forcefield_active = false
	

func activate_ice_powerup() -> void:
	iced_up = true
	$ice_timer.start(ice_powerup_duration)
	
	if $ship.animation == "tilt_left":
		var current_frame = $ship.frame
		$ship.play("ice_tilt_left")
		$ship.frame = current_frame
	if $ship.animation == "tilt_right":
		var current_frame = $ship.frame
		$ship.play("ice_tilt_right")
		$ship.frame = current_frame
	

func _on_ice_timer_timeout() -> void:
	iced_up = false
	


# theres prob a better way of doing this but these set up the signal to change the HUD
func update_health_changed(updated_health):
	if last_health != updated_health:
		last_health = updated_health
		SignalBus.health_changed.emit(updated_health)
		if health <= 2 and not $low_health_alert.playing:
			$low_health_alert.play(0.1)


func update_ammo_changed(updated_ammo):
	if last_ammo != updated_ammo:
		last_ammo = updated_ammo
		SignalBus.ammo_changed.emit(updated_ammo)

func update_boost_changed(updated_boost):
	if last_boost != updated_boost:
		last_boost = updated_boost
		SignalBus.boost_changed.emit(updated_boost)

	
func change_max_health(added_amount):
	max_health += added_amount
	health += added_amount

func hurt_player(dmg : int):
	if not forcefield_active:
		adjust_health(dmg)
		SignalBus.apply_camera_shake.emit(1)


func play_death():
	if not dead:
		SignalBus.player_died.emit()
	super()
	update_health_changed(0)
	

# restart game - should probs be in game
func _process(_delta: float) -> void:
	if dead:
		if Input.is_action_pressed("restart"):
			get_tree().change_scene_to_file("res://game/global_ish/game.tscn")


func _on_low_health_alert_cooldown_timeout() -> void:
	if health <= 2:
		$low_health_alert.play()
		$low_health_alert_cooldown.start(5)
