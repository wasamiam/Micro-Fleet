extends "res://turrets/bullet_turret.gd"

onready var rotation_speed = deg2rad(90)
onready var rotator_node = get_node("Rotator")

func fire():
	var bullet_instance = bullet.instance()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.damage = damage
	bullet_instance.look_at(get_viewport().get_mouse_position())
	bullet_instance.velocity_vector = Vector2(1,0).rotated(bullet_instance.rotation)
#func _process(delta):
#	rotator_node.look_at(get_viewport().get_mouse_position())
#	if is_instance_valid(target):
#		var rads = Vector2(1,0).rotated(get_node("Rotator").rotation).angle_to(Vector2(1,0).rotated(get_angle_to(target)))#.position)))
#		if abs(rads) < deg2rad(1):
#			#emit_signal("find_target", self)
#			pass
#		elif rads < deg2rad(0):
#			get_node("Rotator").rotate(-rotation_speed * delta)#rotate left (neg)
#		elif rads > deg2rad(0):
#			get_node("Rotator").rotate(rotation_speed * delta)#rotate right (pos)
#
#func _on_Timer_timeout():
#	if firing:
#		fire()
