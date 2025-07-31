extends AnimatedSprite2D

var active := false

func expand():
	print("tried")
	if not active:
		active = true
		show()
		play("expand")
		$".".self_modulate.a = 0.5
		$hide_timer.start(2)

func dexpand():
	active = false
	play("dexpand")
	await animation_finished
	#hide()
	

func _on_hide_timer_timeout() -> void:
	await dexpand()
	hide()
