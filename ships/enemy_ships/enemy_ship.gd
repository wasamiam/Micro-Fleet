extends "res://ships/ship.gd"

var final_position
var damage_boost = 0.0

func _ready():
	$Line2D.add_point(Vector2(0,0))
	$Line2D.add_point(Vector2(-640, 0))
	$Tween.connect("tween_all_completed", self, "_tween_all_completed")
	$Tween.interpolate_method(self, "change_line_length", $Line2D.points[1].x, 0, 1)
	$Tween.interpolate_property(self, "position", position, Vector2(final_position), 0.5)
	$Tween.interpolate_property($Sprite, "modulate", Color(100, 100, 100, 1), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN) 
	$Tween.start()

func apply_damage(damage):
	if health - damage <= 0:
		$CollisionPolygon2D.set_deferred("disabled", true)
		$Explosion.show()
		$Explosion.play()
		Main.experience += 5.0
	.apply_damage(damage)

func change_line_length(x_pos):
	$Line2D.set_point_position(1, Vector2(x_pos, 0))
	
func _tween_all_completed():
	$Line2D.hide()
	$Engine.emitting = true
	$CollisionPolygon2D.disabled = false

func _on_Explosion_animation_finished():
	queue_free()
