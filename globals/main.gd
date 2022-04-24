extends Node


var battle_screen_packed = preload("res://screens/battle_screen/battle_screen.tscn")
var win_screen_packed = preload("res://screens/end_condition_screens/win_screen.tscn")


var fleet = {}
var enemy_fleet = {}
var level = 1
var final_level = 4

func start_game():
	#load game
	
	#start new game if no save exists
	setup_new_game()
	start_battle()

func start_battle():
	update_enemy_fleet(level)
	get_tree().change_scene_to(battle_screen_packed)

func setup_new_game():
	fleet = {"nebulon_b":1} #{ship name:number of ships}

func update_enemy_fleet(p_level):
	match p_level:
		1:
			enemy_fleet = {"raider":1}
		2:
			enemy_fleet = {"raider":2}
		3:
			enemy_fleet = {"raider":3}
		4:
			enemy_fleet = {"light_cruiser":1}

func win_condition():
	get_tree().change_scene_to(win_screen_packed)
