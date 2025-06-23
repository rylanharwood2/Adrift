extends "res://scripts/bullet.gd"

func _init() -> void:
	$despawn_timer.start(5)

func _on_despawn_timer_timeout() -> void:
	# kill the bullets that exit the screen, helps with lag
	print("explode")
