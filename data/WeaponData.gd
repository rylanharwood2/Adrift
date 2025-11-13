extends Resource
class_name WeaponData

@export var weapon_name : String
@export var damage : float
@export var fire_rate : float
@export var shoot_cooldown : float
@export var projectile_scene : PackedScene
@export var sprite : Texture2D
@export var durability : int = 10
@export var has_durability : bool = true
