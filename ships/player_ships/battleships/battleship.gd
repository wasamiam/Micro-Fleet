extends "res://ships/ship.gd"

func _ready():
	get_node("Health").max_value = max_health
	get_node("Health").value = health

func activate_shield(shield_direction):
	var collision = $Shield/Area2D/CollisionPolygon2D
	var shield = $Shield
	var angle = deg2rad(0)
	var hidden = false
	match shield_direction:
		"up_right":
			angle = deg2rad(-45)
		"down_right":
			angle = deg2rad(45)
		"up_left":
			angle = deg2rad(-135)
		"down_left":
			angle = deg2rad(135)
		"right":
			angle = deg2rad(0)
		"down":
			angle = deg2rad(90)
		"up":
			angle = deg2rad(-90)
		"left":
			angle = deg2rad(180)
		"none":
			hidden = true
	if hidden == true:
		collision.disabled = true
		shield.hide()
	else:
		shield.show()
		collision.disabled = false
	shield.rotation = angle

func apply_damage(damage):
	if health - damage <= 0:
		emit_signal("check_for_win_condition", self)
	.apply_damage(damage)

func _process(delta):
	if Input.is_action_pressed("shield_right") and Input.is_action_pressed("shield_up"):
		activate_shield("up_right")
	elif Input.is_action_pressed("shield_right") and Input.is_action_pressed("shield_down"):
		activate_shield("down_right")
	elif Input.is_action_pressed("shield_left") and Input.is_action_pressed("shield_up"):
		activate_shield("up_left")
	elif Input.is_action_pressed("shield_left") and Input.is_action_pressed("shield_down"):
		activate_shield("down_left")
	elif Input.is_action_pressed("shield_right"):
		activate_shield("right")
	elif Input.is_action_pressed("shield_down"):
		activate_shield("down")
	elif Input.is_action_pressed("shield_up"):
		activate_shield("up")
	elif Input.is_action_pressed("shield_left"):
		activate_shield("left")
	else:
		activate_shield("none")

func _set_health(p_health):
	._set_health(p_health)
	get_node("Health").value = health
