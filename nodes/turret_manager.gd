extends Node2D

class_name TurretManager

export(float) var time_between_firing

var firing_order:Array #
var timer

onready var firing = true setget _set_firing

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.start(time_between_firing)
	#_set_firing(true)

#func _set_firing(p_firing:bool):
#	firing = p_firing
#	for i in get_children():
#		i.firing = p_firing

func _on_timeout():
	if not Input.is_action_pressed("fire"):
		return
	if firing_order.empty():
		firing_order = get_children().duplicate(true)
		firing_order.erase(timer)
	var turret = firing_order.pop_back()
	if not turret is Timer:
		turret.fire()


func _set_firing(p_firing):
	firing = p_firing
	
