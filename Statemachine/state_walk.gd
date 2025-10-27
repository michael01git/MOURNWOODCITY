extends State
class_name WalkState

@export var fall_state: FallState
@export var inventory_state: InventoryState

@onready var flip_able: Node2D = $"../../FlipAble"
@onready var sprite: Sprite2D = $"../../PlayerSprite"
@onready var raycast_top: RayCast2D = $"../../FlipAble/ClimbingRays/RaycastTop"
@onready var raycast_middle: RayCast2D = $"../../FlipAble/ClimbingRays/RaycastMiddle"
@onready var position_raycast: RayCast2D = $"../../FlipAble/ClimbingRays/PositionRaycast"
@onready var raycast_bottom: RayCast2D = $"../../FlipAble/ClimbingRays/RaycastBottom"
@onready var interact_area: Area2D = $"../../InteractArea"

const SPEED: float = 300
const JUMP_FORCE: float = 500
@export var DRAG: float = 0.5
@export var MAX_SPEED: float = 300
var player_input: Vector2



## State process.
func state_process(delta: float):
	# Get player input. (Vertical input, player_input.x)
	get_player_input()
	# Move player every.
	move_player(delta)
	
	check_if_jumping(delta)
	
	

## State input.
func state_input(event: InputEvent):
	if event.is_action_pressed("inventory"):
		if player_input == Vector2.ZERO:
			next_state = inventory_state
			
	elif event.is_action("use"):
		use()

func use():
	var areas: Array
	areas = interact_area.get_overlapping_areas()
	if !areas.is_empty():
		areas[0].interact(player)

#Get Player Input
func get_player_input():
	
	var dir: Vector2
	
	dir.x = Input.get_axis("move_left","move_right")
	
	
	player_input = dir
	
	if player_input == Vector2.ZERO:
		animation_player.play("idle")
	else:
		animation_player.play("run")


func check_if_jumping(delta):
	
	
	
	#If jump
	if Input.is_action_just_pressed("jump"):
		if (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")) and raycast_bottom.is_colliding():
			# If moving to direction.
			# If next to walldd
			climb()
			
		else:
			jump()
		



func climb():
	if !raycast_top.is_colliding() and raycast_middle.is_colliding():
		position_raycast.position = raycast_top.position + raycast_top.target_position
		position_raycast.force_raycast_update()
		var new_pos = position_raycast.get_collision_point()
		
		player.global_position = new_pos + Vector2.UP*100
		
		

func jump():
	if player.is_on_floor():
		player.velocity = player.velocity + Vector2.UP * JUMP_FORCE
		player.move_and_slide()
		next_state = fall_state

func move_player(delta):
	
	if !player.is_on_floor():
		next_state = fall_state
	
	# If player is not moving, drag.
	if player_input == Vector2.ZERO:
		player.velocity.x = lerpf(player.velocity.x, 0, DRAG)
		player.move_and_slide()
		return
	
	# Add velocity.
	player.velocity += player_input * SPEED * delta
	# Cap velocity.
	
	
	
	if abs(player.velocity.x) > MAX_SPEED:
		player.velocity = player.velocity.limit_length(MAX_SPEED)
	
	
	# Move.
	player.move_and_slide()
	update_facing_direction()
	


func update_facing_direction():
	if player_input.x > 0:
		sprite.flip_h = false
		flip_able.scale.x = 2
	elif player_input.x < 0:
		sprite.flip_h = true
		flip_able.scale.x = -2


## State enter and exit on change.
func on_exit():
	pass

func on_enter():
	animation_player.play("idle")
