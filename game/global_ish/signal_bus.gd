extends Node

@warning_ignore_start("unused_signal")
# Global Signals

# Gamestate / leaderboard 
signal game_finished
signal final_time_sent(String)
signal gamestate_changed(new_state)
signal leaderboard_data_received(leaderboard_data : Array)
signal leaderboard_data_requested

signal submit_player_text_input(text: String)
signal get_personal_best
signal personal_best_verified(was_best: bool)
signal final_time_requested
signal submit_leaderboard_time(player_name : String)

# Wave end logic
signal select_upgrade_reward
signal display_reward_menu
signal add_new_ability(String)

# Player logic
signal player_died
signal healthpack_captured(int)
signal health_changed(new_health)
signal ammo_changed(new_ammo)
signal boost_changed(new_boost)
signal change_max_health(added_value)
signal apply_camera_shake(shake_strength : float)

signal mine_boom(explosion_location)

# Weapon logic
signal weapon_broken
signal ability_used(String)
signal applied_recoil(float)
signal railgun_shot(float)


@warning_ignore_restore("unused_signal")
