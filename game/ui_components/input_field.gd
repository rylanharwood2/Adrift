extends CanvasLayer

#signal input_text_submitted

func _on_submit_button_pressed() -> void:
	if $VBoxContainer/input_field.text != "":
		SignalBus.submit_player_text_input.emit($VBoxContainer/input_field.text)
