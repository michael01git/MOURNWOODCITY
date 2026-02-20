extends Area3D

@export var item: Item

func pick_item():
	queue_free()
	return item
