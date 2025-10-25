extends CharacterBody3D

@export var SPEED: int = 10
@export var TURN_SPEED: int = 5

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot"):
	#	shoot()
	#if Input.is_action_pressed("quit_debug"):
	#	get_tree().quit()
	move_player(delta)

func shoot():
	pass
	# Input.start_joy_vibration(0, 0.5, 0.5, 1)

func move_player(delta: float):
	var horizontal_input: int = get_horizontal_input()
	velocity = self.global_basis.z * horizontal_input * SPEED * delta
	
	rotate(Vector3.UP, get_turn_input(delta))
	move_and_slide()

func get_horizontal_input():
	var input: int = 0
	input = Input.get_axis("move_forward", "move_back")
	return input

func get_turn_input(delta: float):
	var turn: float = 0.0
	var turn_input: int = Input.get_axis("turn_right", "turn_left")
	turn = turn_input * delta * TURN_SPEED
	return turn
