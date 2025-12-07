extends Node
class_name State

var player: CharacterBody3D
var animation_tree: AnimationTree

## The next state. StateMachine looks at this and if its not null changes to that state.
var next_state: State

## State process.
func state_process(delta: float):
	pass

func state_input(event: InputEvent):
	pass

## State enter and exit on change.
func on_exit():
	pass

func on_enter():
	pass
