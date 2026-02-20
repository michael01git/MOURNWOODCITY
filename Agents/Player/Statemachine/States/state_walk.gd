extends State
class_name WalkState

@onready var idle_state: IdleState = $"../IdleState"
@onready var shoot_state: Node = $"../ShootState"

@export var SPEED: int = 5


@onready var travel_area_forward_ray: RayCast3D = $"../../TravelAreaForwardRay"
@onready var travel_area_back_ray: RayCast3D = $"../../TravelAreaBackRay"
@onready var travel_area_normal_ray: RayCast3D = $"../../TravelAreaNormalRay"

func state_process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot"):
	#	shoot()
	#if Input.is_action_pressed("quit_debug"):
	#	get_tree().quit()
	if Input.is_action_pressed("aim"):
		next_state = shoot_state
		
	
	move_player(delta)
	
	


func move_player(delta: float):
	
	var horizontal_input: float = get_horizontal_input()
	var turn_input: float = get_turn_input(delta)
	
	if horizontal_input == 0 and turn_input == 0:
		next_state = idle_state
	
	player.velocity = player.global_basis.z * horizontal_input * SPEED * delta
	player.rotate(Vector3.UP, turn_input)
	
	
	if canMoveRay(horizontal_input):
		player.move_and_collide(player.velocity)
		if (travel_area_normal_ray.get_collision_point() - player.global_position).length() > 1.0:
			player.global_position.y = travel_area_normal_ray.get_collision_point().y + 1

func canMoveRay(horizontal_input: int) -> bool:
	var canMove = false
	if (horizontal_input == -1 && travel_area_forward_ray.is_colliding()) or (horizontal_input == 1 && travel_area_back_ray.is_colliding()): canMove = true
	return canMove

func get_horizontal_input():
	var input: float = 0
	input = Input.get_axis("move_forward", "move_back")
	return input

func get_turn_input(delta: float) -> float:
	var turn: float = 0.0
	var turn_input: float = Input.get_axis("turn_right", "turn_left")
	turn = turn_input * delta * player.TURN_SPEED
	return turn
