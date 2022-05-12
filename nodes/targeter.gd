extends Node

class_name Targeter

var target

func _ready():
	pass

func find_new_target():
	Signals.emit_signal("target_needed", self)
