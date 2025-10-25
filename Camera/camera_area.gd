extends Area3D

func _ready() -> void:
	connect("body_entered", set_active)

func set_active(body):
	get_parent().set_active()
