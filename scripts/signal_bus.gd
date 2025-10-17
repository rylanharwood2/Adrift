extends Node

# Global Signals
signal gamestate_changed(new_state)

signal applied_ice
signal start_game
signal health_pack_entered(int)

signal player_died(message, bool)
signal healthpack_captured
signal health_changed(new_health)
signal ammo_changed(new_ammo)
signal boost_changed(new_boost)
