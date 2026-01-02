extends Control

@export var items: Array[InventoryItem]
@export var focus_button: Button


## Called from inventorystate
func open_inventory():
	visible = true
	focus_button.grab_focus.call_deferred()

func close_inventory():
	visible = false
