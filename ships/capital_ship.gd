extends KinematicBody2D

signal find_target(targeting_ship)
signal check_for_win_condition(ship)

export(int) var damage
export var bullet_color:Color
export(PackedScene) var bullet
export(float) var velocity
export(Vector2) var direction_vector
export(float) var health setget _set_health
export(int, "battleship_ally", "battleship_enemy", "cruiser_ally", "cruiser_enemy", "corvette_ally", "corvette_enemy", "bomber_ally", "bomber_enemy", "fighter_ally", "fighter_enemy") var ship_type
export(Array, String) var order_of_attack

var firing:bool setget _set_firing
var target setget _set_target
var amount setget _set_amount

func _ready():
	get_node("Health").max_value = health
	get_node("Health").value = health
	
	for i in get_node("Turrets").get_children():
		i.connect("find_target", self, "find_target")
		i.damage = damage
		i.bullet_color = bullet_color
		i.bullet = bullet
		i.get_node("Timer").start()

func _set_firing(p_firing:bool):
	firing = p_firing
	for i in get_node("Turrets").get_children():
		i.firing = p_firing

func _set_health(p_health):
	
	if p_health <= 0:
		if amount == 1:
			emit_signal("check_for_win_condition", self)
			queue_free()
		
		_set_amount(amount - 1)
		health = get_node("Health").max_value
	else:
		health = p_health
	
	get_node("Health").value = health
	
func _set_target(p_target):
	target = p_target
	if has_node("Turrets"):
		for i in get_node("Turrets").get_children():
			i.target = p_target

func _set_amount(p_amount):
	amount = p_amount
	get_node("Amount").text = String(p_amount)

func find_target():
	emit_signal("find_target", self)
