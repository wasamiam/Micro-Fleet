extends Position2D

var bullet
var bullet_color:Color

onready var firing = false
var target

func _ready():
	$Timer.wait_time = rand_range(0.5, 1)
	pass

# Used to offset the bullet target, so they all don't converge at the same point.
func offset_target_position(target_position:Vector2):
	var ship = get_parent().get_parent()
	var offset = global_position.x - ship.global_position.x
	var offset_position = target_position
	offset_position.x += offset
	return offset_position
	

func calculate_lead(bullet_position, bullet_velocity, target_position, target_velocity_vector:Vector2):
	var distance = target_position.distance_to(bullet_position)
	var time = distance / bullet_velocity
	var future_target_position = target_position + target_velocity_vector * time * 1.6
	return offset_target_position(future_target_position)

func fire():
	update()
	var bullet_instance = bullet.instance()
	bullet_instance.get_node("Polygon2D").color = bullet_color
	add_child(bullet_instance)
	var lead_position = calculate_lead(global_position, bullet_instance.velocity, target.position, target.velocity * target.direction_vector)
	bullet_instance.velocity_vector = global_position.direction_to(lead_position).rotated(get_parent().get_parent().rotation)
	bullet_instance.look_at(lead_position)

func _on_Timer_timeout():
	if firing and is_instance_valid(target):
		fire()

