extends Node3D

@onready var run_animation_player: AnimationPlayer = $RunAnimationPlayer
@onready var idle_animation_player: AnimationPlayer = $IdleAnimationPlayer

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back"):
		idle_animation_player.stop()
		run_animation_player.play("Root|Run")
	else:
		run_animation_player.stop()
		idle_animation_player.play("Root|Idle")
