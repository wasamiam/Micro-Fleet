extends Button

signal item_selected(item)

var item_id

func _on_ItemCard_pressed():
	emit_signal("item_selected", self)
