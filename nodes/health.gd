extends Node

class_name Health

signal health_changed()
signal health_empty()

export(float) var max_health

onready var health = max_health

func apply_damage(damage:float):
	health -= damage
	emit_signal("health_changed")
	if health <= 0:
		emit_signal("health_empty")

func heal(heal_amount:float):
	health += heal_amount
	emit_signal("health_changed")

func reset():
	health = max_health
