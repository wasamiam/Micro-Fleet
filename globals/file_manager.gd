extends Node

func save_game():
	pass

func load_game():
	pass

func load_items():
	var items = {}
	var dir = Directory.new()
	if dir.open("res://items/") == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.get_extension() == "tres":
				items[file_name.get_file().get_basename()] = load(dir.get_current_dir() + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return items
