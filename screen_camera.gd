extends Camera3D

@export var screen_texture: CompressedTexture2D

@onready var screen_texture_rect = get_tree().get_first_node_in_group("BackgroundImage")

@onready var area:= get_child(0)

func _ready() -> void:
	if area != null:
		area.connect("body_entered", player_in_area)

func player_in_area(body):
	current = true
	screen_texture_rect.texture = screen_texture
