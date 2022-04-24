extends Control

var battle_scene = preload("res://screens/battle_screen/battle_screen.tscn")

func _on_StartButton_pressed():
	Main.start_game()
