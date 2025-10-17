extends Node

enum GameState {
	MAIN_MENU,
	PAUSED,
	PLAYING
}

var current_state: GameState = GameState.MAIN_MENU

func set_state(new_state: GameState) -> void:
	current_state = new_state
	#print("Game state changed to: ", current_state)
	SignalBus.gamestate_changed.emit(new_state)
