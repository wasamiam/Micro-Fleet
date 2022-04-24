extends Node


var end_screen_packed = preload("res://screens/end_condition_screens/lose_screen.tscn")

var home_one = preload("res://ships/battleships/ally/home_one.tscn")
var star_destroyer = preload("res://ships/battleships/enemy/star_destroyer.tscn")
var nebulon_b = preload("res://ships/cruisers/ally/nebulon_b.tscn")
var light_cruiser = preload("res://ships/cruisers/enemy/light_cruiser.tscn")
var cr90 = preload("res://ships/corvettes/ally/cr90.tscn")
var raider = preload("res://ships/corvettes/enemy/raider.tscn")

# Track next available position in ship formation.
var allies_formation
var enemies_formation

func _ready():
	get_node("GUILayer/BattleDebrief").hide()
	get_tree().paused = false
	setup_battlefield()

func setup_battlefield():
	add_ships(Main.fleet)
	add_ships(Main.enemy_fleet)
	for i in get_tree().get_nodes_in_group("ships"):
		_find_target(i)
		i.firing = true

# Instead of splitting ships in ally and enemy ship types, ships are dynamically made ally or enemy, so any ship can be used.
func add_ships(ships:Dictionary):
	for i in ships:
		match i:
			"home_one":
				add_ship(home_one, "battleship", "ally", ships[i])
			"star_destroyer":
				add_ship(star_destroyer, "battleship", "enemy", ships[i])
			"nebulon_b":
				add_ship(nebulon_b, "cruiser", "ally", ships[i])
			"light_cruiser":
				add_ship(light_cruiser, "cruiser", "enemy", ships[i])
			"cr90":
				add_ship(cr90, "corvette", "ally", ships[i])
			"raider":
				add_ship(raider, "corvette", "enemy", ships[i])

func add_ship(packed_ship:PackedScene, ship_type:String, ship_side, amount):
	var ship = packed_ship.instance()
	
	ship.add_to_group("ships")
	ship.add_to_group(ship_type)
	ship.add_to_group(ship_side)
	
	ship.amount = amount
	ship.position = get_formation_position(ship_type, ship_side)
	ship.connect("check_for_win_condition", self, "check_for_win_condition")
	ship.connect("find_target", self, "_find_target")
	add_child(ship)

func get_formation_position(ship_type, ship_side):
	match ship_type:
		"battleship":
			if ship_side == "ally":
				return get_node("BattleshipAlly").position
			else:
				return get_node("BattleshipEnemy").position
		"cruiser":
			if ship_side == "ally":
				return get_node("CruiserAlly").position
			else:
				return get_node("CruiserEnemy").position
		"corvette":
			if ship_side == "ally":
				return get_node("CorvetteAlly").position
			else:
				return get_node("CorvetteEnemy").position

func _find_target(targeting_ship:Node):
	var target_side
	if targeting_ship.is_in_group("ally"):
		target_side = "enemy"
	if targeting_ship.is_in_group("enemy"):
		target_side = "ally"
	
	for i in targeting_ship.order_of_attack:
		var targets = get_tree().get_nodes_in_group(i)
		if targets.empty():
			continue
		for j in targets:
			if j.is_in_group(target_side):
				targeting_ship.target = j
				return
	
	targeting_ship.firing = false

func lose_condition():
	get_tree().change_scene_to(end_screen_packed)

# Check if ship sending signal is last to be destoryed.
func check_for_win_condition(ship):
	if ship.is_in_group("enemy") and get_tree().get_nodes_in_group("enemy").size() == 1:
		get_tree().paused = true
		if Main.level == Main.final_level:
			Main.win_condition()
		get_node("GUILayer/BattleDebrief").show()
	elif ship.is_in_group("ally") and get_tree().get_nodes_in_group("ally").size() == 1:
		lose_condition()

func add_ship_to_fleet():
	if !Main.fleet.has("cr90"):
		Main.fleet["cr90"] = 1
	else:
		Main.fleet["cr90"] += 1
	Main.level += 1
	
	
	Main.start_battle()
