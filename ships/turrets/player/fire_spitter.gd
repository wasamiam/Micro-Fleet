extends "res://ships/turrets/bullet_turret.gd"

onready var rotation_speed = deg2rad(90)

func fire():
	var bullet_instance = bullet.instance()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.damage = damage
	bullet_instance.rotate(get_node("Rotator").rotation)
	bullet_instance.velocity_vector = Vector2(1,0).rotated(get_node("Rotator").rotation)
	

func _process(delta):
	if is_instance_valid(target):
		var rads = Vector2(1,0).rotated(get_node("Rotator").rotation).angle_to(Vector2(1,0).rotated(get_angle_to(target.position)))
		if abs(rads) < deg2rad(1):
			emit_signal("find_target", self)
		elif rads < deg2rad(0):
			get_node("Rotator").rotate(-rotation_speed * delta)#rotate left (neg)
		elif rads > deg2rad(0):
			get_node("Rotator").rotate(rotation_speed * delta)#rotate right (pos)
