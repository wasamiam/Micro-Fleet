extends Position2D

signal find_target()

var damage
var bullet
var bullet_color:Color

onready var firing = false
var target

func _ready():
	$Timer.wait_time = rand_range(0.5, 1)
	pass

func fire():
	update()
	var bullet_instance = bullet.instance()
	bullet_instance.damage = damage
	bullet_instance.get_node("Polygon2D").color = bullet_color
	bullet_instance.set_collision_mask_bit(target.ship_type, true)
	add_child(bullet_instance)
	bullet_instance.velocity_vector = global_position.direction_to(target.position).rotated(get_parent().get_parent().rotation)
	bullet_instance.look_at(target.position)

func _on_Timer_timeout():
	if firing:
		if is_instance_valid(target):
			fire()
		else:
			emit_signal("find_target")
