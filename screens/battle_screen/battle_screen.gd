extends Node2D

var cr90 = preload("res://ships/capital_ships/cr90.tscn")
var raider = preload("res://ships/capital_ships/raider_corvette.tscn")
var x_wing = preload("res://ships/fighters/x_wing.tscn")

onready var allies = {"cr90":2}
onready var enemies = {"raider":1}
onready var max_capital_ships = 5

func _ready():
	setup_battlefield()

func setup_battlefield():
	add_ships(allies, "allies")
	add_ships(enemies, "enemies")
	for i in get_tree().get_nodes_in_group("ships"):
		_find_target(i)
		i.set_physics_process(false)
	get_node("AnimationPlayer").play("CameraZoomIntro")

func add_ships(ships:Dictionary, group_side:String):

	var ship_position_name:String
	
	for i in ships:
		var packaged_ship
		var formation_position = 1
		match i:
			"cr90":
				packaged_ship = cr90
			"x_wing":
				packaged_ship = x_wing
			"raider":
				packaged_ship = raider
		
		for n in ships[i]:
			var ship = packaged_ship.instance()
			if group_side == "enemies":
				ship.rotate(deg2rad(180.0))
				ship_position_name = "EnemyStartPosition"
			else:
				ship_position_name = "AllyStartPosition"
			
			ship.add_to_group(group_side)
			add_ship(ship, "capital_ships", get_node(ship_position_name + String(formation_position)).global_position)
			formation_position = clamp(formation_position + 1, 1, max_capital_ships)


func add_ship(ship:Node, group:String, p_position:Vector2):
	ship.add_to_group("ships")
	ship.add_to_group(group)
	ship.position = p_position
	ship.connect("find_target", self, "_find_target")
	add_child(ship)

# Return position vector based on 


func _find_target(targeting_ship:Node):
	if !"target" in targeting_ship:
		return
	
	var side = "allies" if targeting_ship.is_in_group("allies") else "enemies"
	
	var targets = []
	
	if targeting_ship.is_in_group("capital_ships"):
		targets = get_tree().get_nodes_in_group("capital_ships")
	elif targeting_ship.is_in_group("fighter"):
		targets = get_tree().get_nodes_in_group("bombers")
		if targets.empty():
			targets = get_tree().get_nodes_in_group("fighter_bombers")
		if targets.empty():
			targets = get_tree().get_nodes_in_group("fighters")
	elif targeting_ship.is_in_group("fighter/bomber"):
		targets = get_tree().get_nodes_in_group("bombers")
		if targets.empty():
			targets = get_tree().get_nodes_in_group("fighter_bombers")
		if targets.empty():
			targets = get_tree().get_nodes_in_group("fighters")
		if targets.empty():
			targets = get_tree().get_nodes_in_group("capital_ships")
	elif targeting_ship.is_in_group("bomber"):
		targets = get_tree().get_nodes_in_group("capital_ships")
		if targets.empty():
			targets = get_tree().get_nodes_in_group("bombers")
		if targets.empty():
			targets = get_tree().get_nodes_in_group("fighter_bombers")
		if targets.empty():
			targets = get_tree().get_nodes_in_group("fighters")
	else:
		if targets.empty():
			return
	
	var final_targets = []
	for i in targets:
		if i.is_in_group(side):
			continue
		else:
			final_targets.append(i)
	
	var closest_target = final_targets.pop_front()
	for i in final_targets:
		if targeting_ship.global_position.distance_to(i.global_position) < targeting_ship.global_position.distance_to(closest_target.global_position):
			closest_target = i
	
	targeting_ship.target = closest_target

func _process(delta):
	#get_node("Camera2D").zoom -= Vector2(0.02 * delta, 0.02 * delta)
	#print(get_node("Camera2D").zoom)
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	for i in get_tree().get_nodes_in_group("ships"):
		i.set_physics_process(true)
		i.firing = true
