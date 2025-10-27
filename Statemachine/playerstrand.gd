extends CharacterBody2D

@onready var player_collider: CollisionShape2D = $PlayerCollider
@onready var player_sprite: Sprite2D = $PlayerSprite

@export var player_variables: Resource
@export var collision_shape_offset: Vector2 = Vector2(30, 0)

@onready var inventory_ui: Control = $CanvasLayer/InventoryUI

func pick_up_item(item: Resource):
	inventory_ui.add_item(item)

func _process(delta: float) -> void:
	player_variables.health -= 10
	return
	
	if player_sprite.flip_h:
		player_collider.position = collision_shape_offset
	else:
		player_collider.position = -collision_shape_offset
