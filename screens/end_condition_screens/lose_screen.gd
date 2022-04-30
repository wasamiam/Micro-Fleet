extends Control

func _ready():
	get_node("PanelContainer/CenterContainer/VBoxContainer/VBoxContainer/HBoxContainer/FinalLevelData").text = String(Main.level)

func _on_restart_pressed():
	Main.restart_game()

