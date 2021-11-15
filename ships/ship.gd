extends KinematicBody2D

signal find_target(targeting_ship)

export(float) var velocity
export(Vector2) var direction_vector
export(float) var health setget _set_health

var target setget _set_target

func _physics_process(delta):
	move_and_collide(direction_vector * velocity * delta)

func _set_health(p_health):
	health = p_health
	if health < 0:
		queue_free()

func _set_target(p_target):
	target = p_target
	if has_node("Turrets"):
		for i in get_node("Turrets").get_children():
			i.target = p_target
