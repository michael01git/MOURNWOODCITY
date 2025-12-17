extends Control
## Called from inventorystate

@onready var items_resource = preload("res://Agents/Player/Inventory/inventory_resource.tres")
@export var focus_button: Button

func open_inventory():
	visible = true
	focus_button.grab_focus.call_deferred()

func close_inventory():
	visible = false
