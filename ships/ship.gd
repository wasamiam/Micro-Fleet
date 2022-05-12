extends KinematicBody2D

signal find_target(targeting_ship)
signal add_bullet(bullet, global_pos, velocity_vector)
signal check_for_win_condition(ship)

export(float) var max_health
export(Array, String) var order_of_attack
var target setget _set_target
var firing setget _set_firing

onready var health = max_health setget _set_health


func _ready():
	for i in get_node("Turrets").get_children():
		i.connect("find_target", self, "find_target")
#		i.connect("add_bullet", self, "_add_bullet")
		i.get_node("Timer").start()
		
	_set_firing(true)

func _set_firing(p_firing:bool):
	firing = p_firing
	for i in get_node("Turrets").get_children():
		i.firing = p_firing

func apply_damage(damage):
	_set_health(health - damage)
	
func _set_target(p_target):
	target = p_target
	if has_node("Turrets"):
		for i in get_node("Turrets").get_children():
			i.target = p_target

func find_target(turret):
	emit_signal("find_target", turret)

#func _add_bullet(bullet, global_pos, velocity_vector):
#	emit_signal("add_bullet", bullet, global_pos, velocity_vector)
	
func update_damage(damage):
	for i in get_node("Turrets").get_children():
		i.damage = damage

func _set_health(p_health):
	health = p_health

func increase_firing_speed(speed_multiplier):
	for i in $Turrets.get_children():
		if !i.name == "neutralizer":
			i.get_node("Timer").wait_time *= speed_multiplier

func _on_Explosion_animation_finished():
	queue_free()
