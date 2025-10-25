extends Node3D

@onready var run_animation_player: AnimationPlayer = $RunAnimationPlayer
@onready var idle_animation_player: AnimationPlayer = $IdleAnimationPlayer
@onready var footstep_sound: AudioStreamPlayer = $"../FootstepSound"


func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back"):
		idle_animation_player.stop()
		run_animation_player.play("Root|Run")
		if !footstep_sound.playing: footstep_sound.play()
	else:
		run_animation_player.stop()
		idle_animation_player.play("Root|Idle")
