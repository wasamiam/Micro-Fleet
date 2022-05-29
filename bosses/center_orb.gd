extends "res://turrets/bullet_turret.gd"

func fire():
	var bullet_instance = bullet.instance()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.damage = damage
	bullet_instance.look_at(Main.selected_battleship.global_position)
	bullet_instance.velocity_vector = bullet_instance.global_position.direction_to(Main.selected_battleship.global_position)

func _on_Health_health_changed():
	$AnimationPlayer.play("on_hit")

func _on_Health_health_empty():
	$Timer.stop()
	$CenterOrb/Area2D.set_deferred("monitorable", false)
	$CenterOrb/Area2D.set_deferred("monitoring", false)
	$CenterOrb.hide()
	$AnimationPlayer.play("destroyed")
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "destroyed":
		queue_free()
