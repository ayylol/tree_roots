extends Node3D

@export var number_of_roots := 180
@export var segment_length: float = 0.5
@export var down_angle: float = PI/4
@export var t: Transform3D = Transform3D()

var extend = false
var edge_segments = []

@onready var StartSegment := $Segment

func _ready():
	StartSegment.init(StartSegment.global_position)
	for i in range(number_of_roots):
		var angle = (float(i)/number_of_roots)*2*PI
		StartSegment.extend_dir = Vector3(cos(angle),-sin(down_angle),sin(angle));
		edge_segments.push_back(StartSegment.extend(segment_length))

func _physics_process(_delta):
	if (extend):
		extend_segments()

func _unhandled_input(_event):
	if(Input.is_action_just_pressed("StepSCA")):
		extend_segments()
	if(Input.is_action_just_pressed("ToggleSCA")):
		extend = !extend
	if(Input.is_action_just_pressed("Output")):
		StartSegment.write_tree_to_file(t)

func extend_segments():
	var temp_edge_segments = []
	for segment in edge_segments:
		segment.extend_dir = segment.global_position - segment.get_parent().global_position
		temp_edge_segments.push_back(segment.extend(segment_length))
	edge_segments = temp_edge_segments
