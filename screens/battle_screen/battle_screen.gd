extends Node

onready var level_up_node = $GUILayer/LevelUp

func _ready():
	get_node("GUILayer/BattleDebrief").hide()
	get_tree().paused = false
	setup_battlefield()

func setup_battlefield():
	Main.increase_wave_difficulty()
	add_ships()

func rand_position_in_rect(p_rect_position, p_rect_size):
	return Vector2(rand_range(p_rect_position.x, p_rect_position.x + p_rect_size.x), rand_range(p_rect_position.y, p_rect_position.y + p_rect_size.y))

func get_formation_position(ship_type):
	match ship_type:
		"battleship":
			return get_node("BattleshipSpawn").position
		"enemy":
			var rand = randi() % 2
			var rect
			match rand:
				0:
					rect = get_node("GUILayer/EnemySpawnTop")
				1:
					rect = get_node("GUILayer/EnemySpawnBottom")
			return rand_position_in_rect(rect.rect_position, rect.rect_size)
		"bomb":
			return rand_position_in_rect(get_node("GUILayer/EnemySpawnRight").rect_position, get_node("GUILayer/EnemySpawnRight").rect_size)

func add_ship(p_ship, ship_type, ship_position, ship_side):
	var ship = p_ship
	
	ship.add_to_group("ships")
	ship.add_to_group(ship_type)
	ship.add_to_group(ship_side)
	
	ship.position = ship_position
	ship.connect("check_for_win_condition", self, "check_for_win_condition")
	ship.connect("find_target", self, "_find_target")
	ship.connect("add_bullet", self, "_add_bullet")
	add_child(ship)

func add_enemy_ship(p_enemy_ship):
	var enemy_ship = p_enemy_ship
	var ship_pos = get_formation_position("enemy")
	if "final_position" in enemy_ship:
		enemy_ship.final_position = ship_pos
		ship_pos = Vector2(ship_pos.x - 640, ship_pos.y)
	add_ship(enemy_ship, "dart", ship_pos, "enemy")

# Instead of splitting ships in ally and enemy ship types, ships are dynamically made ally or enemy, so any ship can be used.
func add_ships():
	add_ship(Main.star_razor_packed.instance(), "battleship", get_formation_position("battleship"), "player")

func find_closest_target(turret, target_group):
	var closest_target = get_tree().get_nodes_in_group(target_group).front()
	for i in get_tree().get_nodes_in_group(target_group):
		if i.global_position.distance_to(turret.global_position) < closest_target.global_position.distance_to(turret.global_position):
			closest_target = i
	return closest_target

# Check if ship sending signal is last to be destoryed.
func check_for_win_condition(ship):
	if ship.is_in_group("player") and get_tree().get_nodes_in_group("player").size() == 1:
		Main.lose_condition()

func _find_target(turret):
	var target_side
	if turret.get_parent().get_parent().is_in_group("player"):
		if !get_tree().get_nodes_in_group("enemy").empty():
			var targets = get_tree().get_nodes_in_group("enemy")
			targets.shuffle()
			turret.target = targets.front()
			
			#find_closest_target(turret, "enemy")
	if turret.get_parent().get_parent().is_in_group("enemy"):
		if !get_tree().get_nodes_in_group("player").empty():
			turret.target = find_closest_target(turret, "player")

func add_ship_to_fleet(ship):
	if !Main.fleet.has(ship):
		Main.fleet[ship] = 1
	else:
		Main.fleet[ship] += 1
	Main.level += 1
	Main.start_battle()

func set_enemy_spawn_timer(time):
	get_node("EnemySpawnTimer").wait_time = time

func _process(delta):
	$GUILayer/TimerLabel.text = Main.battle_time_limit - $LevelCompleteTimer.time_left

func _add_bullet(bullet, global_pos, velocity_vector):
	add_child(bullet)

func _on_EnemySpawnTimer_timeout():
	for i in rand_range(Main.current_wave["min_range"], Main.current_wave["max_range"]):
		add_enemy_ship(Main.current_wave["ship_packed"].instance())

func _on_DifficultyIncreaseTimer_timeout():
	Main.increase_wave_difficulty()


func _on_LevelCompleteTimer_timeout():
	Main.win_condition()

func _level_up():
	get_tree().paused = true
	level_up_node.show()

func _on_LevelUp_item_selected(item):
	level_up_node.hide()
	Main.apply_level_up(item.item_id)
	level_up_node.clear_list()
	get_tree().paused = false
