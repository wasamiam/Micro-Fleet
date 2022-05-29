extends CenterContainer

func _unhandled_key_input(event):
	if not get_tree().paused and event.physical_scancode == KEY_ESCAPE and event.pressed and not event.echo:
		get_tree().paused = true
		show()
	if visible and event.physical_scancode == KEY_SPACE and event.pressed and not event.echo:
		hide()
		get_tree().paused = false
