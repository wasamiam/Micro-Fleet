extends Control

func _process(delta):
	$StarRazor.move_and_collide(Vector2(20 * delta,0))

