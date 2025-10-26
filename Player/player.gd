extends CharacterBody3D

@export var SPEED: int = 5
@export var TURN_SPEED: int = 5

@onready var travel_area_forward_ray: RayCast3D = $TravelAreaForwardRay
@onready var travel_area_back_ray: RayCast3D = $TravelAreaBackRay
@onready var travel_area_normal_ray: RayCast3D = $TravelAreaNormalRay

func _process(delta: float) -> void:
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
	
	if canMoveRay(horizontal_input):
		move_and_collide(velocity)
		if (travel_area_normal_ray.get_collision_point() - global_position).length() > 1.0:
			global_position.y = travel_area_normal_ray.get_collision_point().y + 1

func canMoveRay(horizontal_input: int) -> bool:
	var canMove = false
	if (horizontal_input == -1 && travel_area_forward_ray.is_colliding()) or (horizontal_input == 1 && travel_area_back_ray.is_colliding()): canMove = true
	return canMove

func get_horizontal_input():
	var input: int = 0
	input = Input.get_axis("move_forward", "move_back")
	return input

func get_turn_input(delta: float):
	var turn: float = 0.0
	var turn_input: int = Input.get_axis("turn_right", "turn_left")
	turn = turn_input * delta * TURN_SPEED
	return turn
