extends State
class_name IdleState

@onready var walk_state: WalkState = $"../WalkState"
@onready var shoot_state: ShootState = $"../ShootState"
@onready var inventory_state: InventoryState = $"../InventoryState"
@onready var pick_item_state: PickItemState = $"../PickItemState"

func state_process(delta: float):
	if Input.is_action_just_pressed("aim"):
		next_state = shoot_state
	elif Input.is_action_just_pressed("inventory"):
		next_state = inventory_state
	elif Input.is_action_just_pressed("use"):
		next_state = pick_item_state
	elif Input.is_anything_pressed():
		next_state = walk_state
