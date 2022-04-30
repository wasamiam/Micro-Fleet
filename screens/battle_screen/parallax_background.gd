extends ParallaxBackground

export(float) var star_layer_speed

func _process(delta):
	get_node("ParallaxLayer").motion_offset.x -= star_layer_speed * delta
