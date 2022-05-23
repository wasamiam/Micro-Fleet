extends Node

var neutralizer_packed = preload("res://turrets/player/neutralizer.tscn")
var ice_breaker_packed = preload("res://ships/player_ships/ice_breaker.tscn")
var wave_runner_packed = preload("res://ships/player_ships/wave_runner.tscn")
var shield_maiden_packed = preload("res://ships/player_ships/shield_maiden.tscn")

var items
var possible_items
var current_items:Dictionary

func _ready():
	items = FileManager.load_items()
	reset_items()

func reset_items():
	possible_items = items.duplicate(true)
	#possible_items.erase("nanites")
	current_items.clear()

func apply_item(item_id):
	if current_items[item_id].amount == items[item_id].max_stack:
		possible_items.erase(item_id)
	match item_id:
		"ion_booster":
			Main.damage_modifer += .5
		"charge_cycler":
			Main.selected_battleship.increase_firing_speed(0.5)
		"neutralizer":
			if current_items[item_id].amount == 1:
				var neutralizer = neutralizer_packed.instance()
				Main.selected_battleship.get_node("Turrets").add_child(neutralizer)
				neutralizer.name = "neutralizer"
			Main.selected_battleship.get_node("Turrets/neutralizer").amount = current_items[item_id].amount
		"nanites":
			Main.selected_battleship.get_node("Health").heal(20.0)
		"ice_breaker":
			var ice_breaker = ice_breaker_packed.instance()
			var battle_scene = get_tree().current_scene
			battle_scene.add_child(ice_breaker)
			ice_breaker.position = battle_scene.get_node("IceBreakerSpawn").position
		"wave_runner":
			var wave_runner = wave_runner_packed.instance()
			var battle_scene = get_tree().current_scene
			battle_scene.add_child(wave_runner)
			wave_runner.position = battle_scene.get_node("WaveRunnerSpawn").position
		"shield_maiden":
			var shield_maiden = shield_maiden_packed.instance()
			var battle_scene = get_tree().current_scene
			battle_scene.add_child(shield_maiden)
			shield_maiden.position = battle_scene.get_node("ShieldMaidenSpawn" + String(int(current_items[item_id].amount))).position

# Return as many as possible
func get_random_items(p_number_of_items):
	var random_items = []
	var number_of_items = p_number_of_items if p_number_of_items <= possible_items.size() else possible_items.size()
	if number_of_items == 0:
		return []
	for i in number_of_items:
		var values = possible_items.values()
		for j in random_items:
			values.erase(j)
		random_items.append(values[randi() % values.size()])
	return random_items
