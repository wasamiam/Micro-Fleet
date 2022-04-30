extends "res://ships/turrets/turret.gd"

signal add_bullet(bullet, global_pos, velocity_vector)

export(PackedScene) var bullet

func _on_Timer_timeout():
	if firing:
		if is_instance_valid(target):
			fire()
		else:
			emit_signal("find_target", self)
