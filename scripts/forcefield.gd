extends AnimatedSprite2D

var active := false
var invul_time = 2

func expand(init) -> float:
	if not active and not init:
		active = true
		show()
		play("expand")
		$".".self_modulate.a = 0.5
		$hide_timer.start(invul_time)
	if init:
		hide()
		return 0
	return invul_time

func dexpand():
	active = false
	play("dexpand")
	await animation_finished
	

func _on_hide_timer_timeout() -> void:
	await dexpand()
	hide()
