extends Node

## Based on ChrisTutorials

@export var player: CharacterBody3D
@onready var animation_tree: AnimationTree = $"../AnimationTree"

@export var current_state: State

func _ready() -> void:
	## Give the states some common variables, such as the player.
	for i in get_children():
		if i is State:
			i.player = player
			i.animation_tree = animation_tree
		else:
			push_warning("StateMachine has a non state in it.")

func _process(delta: float) -> void:
	$"../StateLabel".text = current_state.name
	
	if current_state.next_state != null:
		switch_state(current_state.next_state)
	current_state.state_process(delta)

func switch_state(new_state: State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	
	current_state.on_enter()

## This an issue at the moment. This only processes code when any kind of input is noticed.
## Thus if we define player input in state input, player input is only updated when an input is noticed.
## Player will keep sliding, because input is put so.
func _input(event: InputEvent) -> void:
	current_state.state_input(event)
