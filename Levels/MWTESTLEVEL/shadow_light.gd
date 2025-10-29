extends DirectionalLight3D

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	look_at(player.global_position)
