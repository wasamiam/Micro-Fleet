extends Area2D

export(int) var velocity = 150
var velocity_vector:Vector2
var damage

func _process(delta):
	position += velocity * velocity_vector * delta


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func _on_Bullet_body_entered(body):
	if "health" in body:
		body.health -= damage
		queue_free()
