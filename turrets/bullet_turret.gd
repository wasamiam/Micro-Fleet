extends "res://turrets/turret.gd"

export(PackedScene) var bullet

onready var firing = true

func _on_Timer_timeout():
	if firing:
		fire()

func fire():
	pass
