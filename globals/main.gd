extends Node


var battle_screen_packed = preload("res://screens/battle_screen/battle_screen.tscn")
var win_screen_packed = preload("res://screens/end_condition_screens/win_screen.tscn")
var end_screen_packed = preload("res://screens/end_condition_screens/lose_screen.tscn")
var star_razor_packed = preload("res://ships/player_ships/battleships/star_razor/star_razor.tscn")
var xian_dart_packed = preload("res://ships/enemy_ships/xian/xian_dart.tscn")

var selected_battleship
var item_list
var waves = [[{"ship_packed":xian_dart_packed, "min_range":2, "max_range":5}]] # Add array of waves
var current_wave
var battle_time_limit
var experience setget _set_experience

onready var max_experience = 100.0

func save_game():
	pass

func load_game():
	return 0

func start_game():
	if load_game() == 0:
		setup_new_game()
	
	start_battle()

func start_battle():
	get_tree().change_scene_to(battle_screen_packed)

func setup_new_game():
	selected_battleship = star_razor_packed
	battle_time_limit = 60.0

func win_condition():
	get_tree().change_scene_to(win_screen_packed)

func lose_condition():
	get_tree().change_scene_to(end_screen_packed)

func restart_game():
	save_game()
	start_battle()

func increase_wave_difficulty():
	if !Main.waves.empty():
		current_wave = waves.pop_front()

func get_random_items():
	pass

func apply_level_up(item_id):
	pass

func _set_experience(p_experience):
	if p_experience > max_experience:
		experience = 0.0
		get_tree().current_scene.level_up()
	else:
		experience = p_experience
