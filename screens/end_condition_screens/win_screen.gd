extends Control

func _process(delta):
	$StarRazor.move_and_collide(Vector2(20 * delta,0))
	$ShieldMaiden.move_and_collide(Vector2(20 * delta,0))
	$ShieldMaiden2.move_and_collide(Vector2(20 * delta,0))
	$WaveRunner.move_and_collide(Vector2(20 * delta,0))
	$IceBreaker.move_and_collide(Vector2(20 * delta,0))

