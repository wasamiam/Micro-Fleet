extends Area2D

onready var velocity = 150
var velocity_vector:Vector2

func _process(delta):
	position += velocity * velocity_vector * delta


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func _on_Bullet_body_entered(body):
	if "health" in body:
		body.health -= 2
		queue_free()
