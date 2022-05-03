extends Area2D

export(int) var velocity = 150
var velocity_vector:Vector2
var damage

func _process(delta):
	position += velocity * velocity_vector * delta

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_Bullet_body_entered(body):
	if body.has_method("apply_damage"):
		body.apply_damage(damage * Main.damage_modifer)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.hide()
	velocity_vector = Vector2(0,0)
	$Explosion.show()
	$Explosion.play()

func _on_Bullet_area_entered(area):
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.hide()
	velocity_vector = Vector2(0,0)
	$Explosion.show()
	$Explosion.play()


func _on_Explosion_animation_finished():
	queue_free()
