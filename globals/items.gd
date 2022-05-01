extends Node

var neutralizer

var items
var possible_items
var current_items:Dictionary

func _ready():
	items = FileManager.load_items()
	possible_items = items.duplicate()

func apply_item(item_id):
	if current_items[item_id].amount == items[item_id].max_stack:
		possible_items.erase(item_id)
	match item_id:
		"ion_booster":
			Main.damage_modifer += .1
		"charge_cycler":
			Main.selected_battleship.increase_firing_speed(0.5)
		"neutralizer":
			if !Main.selected_battleship.get_node("Turrets").get_children().has("neutralizer"):
				Main.selected_battleship.get_node("Turrets").add_child(neutralizer.instance())
			Main.selected_battleship.get_node("Turrets/neutralizer").amount = current_items[item_id].amount

# Return as many as possible
func get_random_items(p_number_of_items):
	var random_items = []
	var number_of_items = p_number_of_items if p_number_of_items <= possible_items.size() else possible_items.size()
	for i in number_of_items:
		var values = possible_items.values()
		for j in random_items:
			values.erase(j)
		random_items.append(values[randi() % values.size()])
	return random_items
