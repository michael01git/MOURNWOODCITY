extends Camera3D

@onready var prerenderMesh : MeshInstance3D = get_tree().get_first_node_in_group("PRM")
@onready var player = get_tree().get_first_node_in_group("Player")
var audio_listener_3d: AudioListener3D

@export var baseImage: Texture2D

func _ready() -> void:
	if current:
		setShaderToCurrent()

func set_active():
	current = true
	setShaderToCurrent()

func setShaderToCurrent():
	#Stop culling.
	#prerenderMesh.global_position = global_position
	prerenderMesh.get_active_material(0).set_shader_parameter("prerenderBackground",baseImage);
