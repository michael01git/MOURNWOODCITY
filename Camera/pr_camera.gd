extends Camera3D

@onready var prerenderMesh : MeshInstance3D = get_tree().get_first_node_in_group("PRM")
@onready var player = get_tree().get_first_node_in_group("Player")
var audio_listener_3d: AudioListener3D


@export var baseImage: CompressedTexture2D
@export var depthImage: CompressedTexture2D
@onready var backUpDepthImage = load("res://OwnPrerenderShader/Base/Default/baseWhiteDepth.png")

@export var maxBlenderDepth: float
@export var minBlenderDepth: float

func _ready() -> void:
	if current:
		setShaderToCurrent()

func set_active():
	current = true
	setShaderToCurrent()

func setShaderToCurrent():
	#Stop culling.
	prerenderMesh.global_position = player.global_position
	
	
	prerenderMesh.get_active_material(0).set_shader_parameter("baseImage",baseImage);
	if depthImage != null:
		prerenderMesh.get_active_material(0).set_shader_parameter("depthImage",depthImage);
		prerenderMesh.get_active_material(0).set_shader_parameter("blender_max_distance",maxBlenderDepth);
		prerenderMesh.get_active_material(0).set_shader_parameter("blender_min_distance",minBlenderDepth);
	else:
		prerenderMesh.get_active_material(0).set_shader_parameter("depthImage",backUpDepthImage);
