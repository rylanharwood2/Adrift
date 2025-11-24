extends AnimatedSprite2D

func _ready() -> void:
	connect("animation_finished", _load_game)
	$boot_timer.timeout.connect(_on_boot_timer_timeout)
	$".".play("default")
	


func _load_game() -> void:
	$boot_timer.start()

func _on_boot_timer_timeout():
	get_tree().change_scene_to_file("res://game/global_ish/game.tscn")
