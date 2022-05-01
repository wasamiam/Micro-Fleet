extends Node


var battle_screen_packed = preload("res://screens/battle_screen/battle_screen.tscn")
var win_screen_packed = preload("res://screens/end_condition_screens/win_screen.tscn")
var end_screen_packed = preload("res://screens/end_condition_screens/lose_screen.tscn")
var star_razor_packed = preload("res://ships/player_ships/battleships/star_razor/star_razor.tscn")
var xian_dart_packed = preload("res://ships/enemy_ships/xian/xian_dart.tscn")

var selected_battleship
var waves = [[{"ship_packed":xian_dart_packed, "min_range":2, "max_range":5}]] # Add array of waves
var current_wave

onready var battle_time_limit = 600
onready var experience = 0.0 setget _set_experience
onready var max_experience = 100.0
onready var damage_modifer = 1.0

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
	selected_battleship = star_razor_packed.instance()

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
	else:
		for i in current_wave:
			i["min_range"] += 1
			i["max_range"] += 1

func _set_experience(p_experience):
	if p_experience >= max_experience:
		experience = p_experience - max_experience
		get_tree().current_scene.experience_bar.value = experience
		get_tree().current_scene.level_up()
	else:
		experience = p_experience
		get_tree().current_scene.experience_bar.value = p_experience
