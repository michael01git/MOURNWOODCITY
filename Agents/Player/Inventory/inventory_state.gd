extends State
class_name InventoryState

@onready var inventory: Control = get_tree().get_first_node_in_group("InventoryUI")
@onready var idle_state: IdleState = $"../IdleState"

func state_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("inventory"):
		inventory.close_inventory()
		next_state = idle_state

func on_enter():
	inventory.open_inventory()
