extends Bullet

func _on_Health_health_changed():
	$AnimationPlayer.play("on_hit")

func _on_Health_health_empty():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.hide()
	velocity_vector = Vector2(0,0)
	$Explosion.show()
	$Explosion.play()
