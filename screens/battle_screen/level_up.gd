extends CenterContainer

signal item_selected(item)

var item_card_packed = preload("res://screens/battle_screen/item_card.tscn")

onready var item_container = $PanelContainer/VBoxContainer/Items

func add_item(item_id, title, icon, description):
	var item_card = item_card_packed.instance()
	item_card.item_id = item_id
	item_card.get_node("MarginContainer/HBoxContainer/Title").text = title
	item_card.get_node("MarginContainer/HBoxContainer/CenterContainer/MarginContainer/Icon").texture = icon
	item_card.get_node("MarginContainer/HBoxContainer/Description").text = description
	item_card.connect("item_selected", self, "_on_item_selected")
	item_container.add_child(item_card)

func fill_list():
	var items = Items.get_random_items(3)
	for i in items:
		add_item(i.item_id, i.title, i.icon, i.description)

func clear_list():
	for i in item_container.get_children():
		i.queue_free()

func _on_item_selected(item):
	emit_signal("item_selected", item)
