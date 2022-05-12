extends KinematicBody2D

signal check_for_win_condition(ship)

onready var health_bar_node = $HealthBar
onready var health_node = $Health

func _ready():
	health_bar_node.max_value = health_node.max_health
	health_bar_node.value = health_node.health

func _on_health_changed():
	health_bar_node.value = health_node.health

func _on_health_empty():
	emit_signal("check_for_win_condition", self)

func increase_firing_speed(speed_multiplier):
	$Turrets/TurretManager.timer.wait_time *= speed_multiplier
