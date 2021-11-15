extends "res://ships/ship.gd"

export (String, "Fighter", "Fighter/Bomber", "Bomber") var type
export (String, "ally", "enemy") var side
var target_side

var bullet = preload("res://ships/turrets/bullets/ally_bullet.tscn")

func _ready():
	match side:
		"ally":
			target_side = "enemy"
		"enemy":
			target_side = "ally"

func find_target():
	var targets
	
	match type:
		"Fighter":
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_bombers")
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_fighter_bombers")
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_fighters")
		"Fighter/Bomber":
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_bombers")
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_fighter_bombers")
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_fighters")
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_capital_ships")
		"Bomber":
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_capital_ships")
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_bombers")
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_fighter_bombers")
			if targets.empty():
				targets = get_tree().get_nodes_in_group(target_side + "_fighters")
		_:
			if targets.empty():
				return
	
	var closest_target = targets[0]
	for i in targets:
		if targets[i] < closest_target:
			closest_target = targets[i]
	
	return closest_target

func face_target(target_global_position:Vector2):
	rotate(position.angle_to(target_global_position))
