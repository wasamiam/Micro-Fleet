extends Node


var battle_screen_packed = preload("res://screens/battle_screen/battle_screen.tscn")
var win_screen_packed = preload("res://screens/end_condition_screens/win_screen.tscn")
var end_screen_packed = preload("res://screens/end_condition_screens/lose_screen.tscn")
var star_razor_packed = preload("res://ships/player_ships/battleships/star_razor/star_razor.tscn")
var xian_dart_packed = preload("res://ships/enemy_ships/xian/xian_dart.tscn")
var xian_claw_packed = preload("res://ships/enemy_ships/xian/xian_claw.tscn")
var mine_packed = preload("res://turrets/bullets/enemy_bullets/mine.tscn")
var rocket_packed = preload("res://turrets/bullets/enemy_bullets/rocket.tscn")


var selected_battleship
var waves = [{"rocket":{"rocket_packed":rocket_packed, "damage":2.0}, "mine": {"mine_packed":mine_packed, "damage": 5.0}, "ships":[{"name":"dart","ship_packed":xian_dart_packed, "damage_boost":0.0, "health_boost": 0, "min_range":2, "max_range":3, "max_amount":3}, {"name":"claw", "ship_packed":xian_claw_packed, "damage_boost":0.0, "health_boost": 0, "min_range":0, "max_range":0, "max_amount": 0}]}] # Add array of waves
var waves_left
var current_wave

onready var wave_difficulty = 0
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
	var error = get_tree().change_scene_to(battle_screen_packed)
	assert(error == OK)

func setup_new_game():
	selected_battleship = star_razor_packed.instance()
	wave_difficulty = 0
	experience = 0.0
	damage_modifer = 1.0
	waves_left = waves.duplicate(true)
	next_wave()
	Items.reset_items()

func win_condition():
	var error = get_tree().change_scene_to(win_screen_packed)
	assert(error == OK)

func lose_condition():
	var error = get_tree().change_scene_to(end_screen_packed)
	assert(error == OK)

func restart_game():
	save_game()
	start_game()

func increase_wave_difficulty():
	wave_difficulty += 1
	get_tree().current_scene.get_node("GUILayer/WaveDifficultyLabel").text = "Wave: " + String(wave_difficulty) # Turn into a signal
	for i in current_wave["ships"]:
		if i["name"] == "claw" and wave_difficulty < 7:
			continue
		i["min_range"] += 1
		i["max_range"] += 2
		i["max_amount"] += 1
		#i["health_boost"] += 5
		#i["damage_boost"] += 1
	#current_wave["mine"].damage += 1.0
	#current_wave["rocket"].damage += 1.0

func next_wave():
	if not waves_left.empty():
		current_wave = waves_left.pop_front()

func _set_experience(p_experience):
	if p_experience >= max_experience:
		experience = p_experience - max_experience
		get_tree().current_scene.experience_bar.value = experience
		get_tree().current_scene.level_up()
	else:
		experience = p_experience
		get_tree().current_scene.experience_bar.value = p_experience
