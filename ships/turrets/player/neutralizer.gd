extends "res://ships/turrets/turret.gd"

onready var amount = 0 setget _set_amount
onready var starting_fire_time = 1.2

func _ready():
	firing = true
	#$Timer.start(starting_fire_time)

func fire():
	if firing:
		rotation = Main.selected_battleship.get_node("Shield").rotation + deg2rad(180.0) - deg2rad(45.0)
		$FireAnimation.show()
		$FireAnimation.play("default")
		$Area2D/CollisionPolygon2D.disabled = false

func _on_Timer_timeout():
	fire()

func _on_FireAnimation_animation_finished():
	$Area2D/CollisionPolygon2D.disabled = true
	$FireAnimation.hide()
	$FireAnimation.stop()
	$FireAnimation.frame = 0

func _set_amount(p_amount):
	amount = p_amount
	$Timer.start(starting_fire_time - 0.2 * amount)
