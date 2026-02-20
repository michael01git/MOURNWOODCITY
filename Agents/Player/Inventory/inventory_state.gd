extends State
class_name InventoryState

@onready var inventory_panel: Control = get_tree().get_first_node_in_group("InventoryPanel")
@onready var idle_state: IdleState = $"../IdleState"

func on_enter():
	inventory_panel.open()

func on_exit():
	inventory_panel.close()

func state_process(delta: float):
	if Input.is_action_just_pressed("inventory"):
		next_state = idle_state
	
	
