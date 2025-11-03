extends Node

# Global Signals
signal gamestate_changed(new_state)
signal select_upgrade_reward
signal display_reward_menu
signal add_new_ability(String)

signal applied_ice
signal start_game

signal player_died(message, bool)
signal healthpack_captured(int)
signal health_changed(new_health)
signal ammo_changed(new_ammo)
signal boost_changed(new_boost)
signal change_max_health(added_value)
signal apply_camera_shake(shake_strength : float)

signal mine_boom(explosion_location)
