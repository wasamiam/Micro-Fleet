extends Node2D

var cr90 = preload("res://ships/capital_ships/cr90.tscn")
var raider = preload("res://ships/capital_ships/raider_corvette.tscn")
var x_wing = preload("res://ships/fighters/x_wing.tscn")

# Track next available position in ship formation.
var allies_formation
var enemies_formation

onready var allies = {"cr90":2}
onready var enemies = {"raider":1}
onready var max_capital_ships = 5

func _ready():
	setup_battlefield()
	start_battle()

func setup_battlefield():
	add_ships(allies, "allies")
	add_ships(enemies, "enemies")
	for i in get_tree().get_nodes_in_group("ships"):
		_find_target(i)
		i.set_physics_process(false)

func start_battle():
	get_node("AnimationPlayer").play("CameraZoomIntro")

func add_ships(ships:Dictionary, group_side:String):
	for i in ships:
		match i:
			"cr90":
				add_ship(cr90, ships[i], group_side, "capital_ships")
			"x_wing":
				add_ship(x_wing, ships[i], group_side, "fighters")
			"raider":
				add_ship(raider, ships[i], group_side, "capital_ships")

func add_ship(packed_ship:PackedScene, amount:int, group_side:String, group_type:String):
	for n in amount:
		var ship_position_name
		var ship = packed_ship.instance()
		if group_side == "enemies":
			ship.rotate(deg2rad(180.0))
			ship_position_name = "EnemyStartPosition"
		else:
			ship_position_name = "AllyStartPosition"
		
		ship.add_to_group("ships")
		ship.add_to_group(group_side)
		ship.add_to_group(group_type)
		
		ship.position = get_next_formation_position(group_side)
		ship.connect("find_target", self, "_find_target")
		add_child(ship)

func get_next_formation_position(group_side:String, ship_size:Vector2):
	var position_vector = Vector2.ZERO
	var start_position = Vector2.ZERO
	
	if group_side == "allies":
		start_position = get_node("AllyStartPosition").global_position
	else:
		start_position = get_node("EnemyStartPosition").global_position
	
	
	
	return position_vector

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
