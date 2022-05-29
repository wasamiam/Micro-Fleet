extends Node2D

signal boss_destroyed()

onready var health_bar = $HealthBar
onready var health_node = $Body/Area2D/Health
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = health_node.max_health
	health_bar.value = health_node.health

func activate_collision():
	$Body/Area2D.set_deferred("monitorable", true)
	$Body/Area2D.set_deferred("monitoring", true)

func start_firing():
	for i in get_node("Turrets").get_children():
		i.get_node("Timer").start(rand_range(3.0, 5.0))

func _on_Health_health_changed():
	health_bar.value = health_node.health
	#animation_player.stop()
	#animation_player.play("on_hit")

func _on_Health_health_empty():
	emit_signal("boss_destroyed")
