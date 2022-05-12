extends "res://turrets/bullet_turret.gd"

func fire():
	var target = $Targeter.target
	if is_instance_valid(target):
		var bullet_instance = bullet.instance()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.global_position = global_position
		bullet_instance.damage = damage + get_parent().get_parent().damage_boost
		bullet_instance.look_at(target.global_position)
		bullet_instance.velocity_vector = bullet_instance.global_position.direction_to(target.global_position)
	else:
		$Targeter.find_new_target()
	
