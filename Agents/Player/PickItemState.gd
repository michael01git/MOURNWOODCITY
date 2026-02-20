extends State
class_name PickItemState

@onready var interact_area: Area3D = $"../../InteractArea"
@onready var idle_state: IdleState = $"../IdleState"

func on_enter():
	var items_in_area: Array[Area3D] = interact_area.get_overlapping_areas()
	if !items_in_area.is_empty():
		var found_item: Item = items_in_area.get(0).pick_item()
		PlayerManager.add_item_force(found_item)
		print("item picked")
	
	next_state = idle_state
