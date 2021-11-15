extends "res://ships/ship.gd"

export var bullet_color:Color
export(PackedScene) var bullet
var firing:bool setget _set_firing

func _ready():
	for i in get_node("Turrets").get_children():
		i.bullet_color = bullet_color
		i.bullet = bullet
		i.get_node("Timer").start()


func _set_firing(p_firing:bool):
	firing = p_firing
	for i in get_node("Turrets").get_children():
		i.firing = p_firing
