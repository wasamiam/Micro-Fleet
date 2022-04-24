extends KinematicBody2D

signal find_target(targeting_ship)
signal check_for_win_condition(ship)

export(float) var velocity
export(Vector2) var direction_vector
export(float) var health setget _set_health
export(int, "battleship_ally", "battleship_enemy", "cruiser_ally", "cruiser_enemy", "corvette_ally", "corvette_enemy", "bomber_ally", "bomber_enemy", "fighter_ally", "fighter_enemy") var ship_type

var target setget _set_target

func _set_health(p_health):
	health = p_health
	if health < 0:
		emit_signal("check_for_win_condition", self)
		queue_free()

func _set_target(p_target):
	target = p_target
	if has_node("Turrets"):
		for i in get_node("Turrets").get_children():
			i.target = p_target
