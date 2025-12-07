extends State
class_name IdleState

@onready var walk_state: WalkState = $"../WalkState"
@onready var shoot_state: Node = $"../ShootState"

func state_process(delta: float):
	if Input.is_action_just_pressed("aim"):
		next_state = shoot_state
	elif Input.is_anything_pressed():
		next_state = walk_state
