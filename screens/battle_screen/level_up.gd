extends CenterContainer

signal item_selected(item)

var item_card_packed = preload("res://screens/battle_screen/item_card.tscn")

onready var nanite_texture = load("res://images/item_icons/nanites.png")
onready var item_container = $PanelContainer/VBoxContainer/Items

func add_item(item_id, title, icon, description):
	var item_card = item_card_packed.instance()
	item_card.item_id = item_id
	item_card.get_node("MarginContainer/HBoxContainer/Title").text = title
	item_card.get_node("MarginContainer/HBoxContainer/CenterContainer/MarginContainer/Icon").texture = icon
	item_card.get_node("MarginContainer/HBoxContainer/Description").text = description
	item_card.connect("item_selected", self, "_on_item_selected")
	#	item_card.focus_neighbour_top = item_container_children.back()
	item_container.add_child(item_card)
	#var item_container_children = item_container.get_children()
	if item_container.get_child_count() == 1:
		item_card.grab_focus()
	

func fill_list():
	var items = Items.get_random_items(3)
	#if items.empty():
	#	var item = Items.items["nanites"]
	#	add_item(item.item_id, item.title, item.icon, item.description)
	#	return
	for i in items:
		add_item(i.item_id, i.title, i.icon, i.description)

func clear_list():
	for i in item_container.get_children():
		i.queue_free()

func _on_item_selected(item):
	
	emit_signal("item_selected", item)
