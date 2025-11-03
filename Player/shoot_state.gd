extends State

@onready var idle_state: IdleState = $"../IdleState"


func on_enter():
	print("aiming")

func state_process(delta: float):
	if Input.is_action_just_released("aim"):
		next_state = idle_state
	
	aim(delta)

func get_turn_input(delta: float) -> float:
	var turn: float = 0.0
	var turn_input: float = Input.get_axis("turn_right", "turn_left")
	turn = turn_input * delta * player.TURN_SPEED
	return turn

func aim(delta: float):
	var turn_input: float = get_turn_input(delta)
	
	player.rotate(Vector3.UP, turn_input)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	print("bang!")
