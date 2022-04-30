extends CenterContainer

signal item_selected(item)

var item_card_packed = "res://screens/battle_screen/item_card.tscn"

onready var item_container = $PanelContainer/VBoxContainer/Items

func add_item(item_id, title, icon, description):
	var item_card = item_card_packed.instance()
	item_card.item_id = item_id
	item_card.get_node("Title").text = title
	item_card.get_node("Icon").texture = icon
	item_card.get_node("Description").text = description
	item_card.connect("button_pressed", self, "_on_item_selected")
	item_container.add_child(item_card)

func clear_list():
	for i in get_children():
		i.queue_free()

func _on_item_selected(item):
	emit_signal("item_selected", item)
