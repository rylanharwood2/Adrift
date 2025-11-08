extends Node2D
class_name Weapon

@export var weapon_data : Resource
var durability : int

func _ready() -> void:
	if weapon_data:
		durability = weapon_data.durability
		
func shoot():
	pass
	
func apply_durability():
	if weapon_data.has_durability:
		durability -= 1
		if durability <= 0:
			SignalBus.weapon_broken.emit()
