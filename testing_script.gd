extends Node3D

var segment_scene = preload("res://segment.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var segment = segment_scene.instantiate()
	segment.end_point = $Point1.global_position
	add_child(segment)
	segment.make_mesh()
	var segment2 = segment_scene.instantiate()
	segment2.start_point = segment.end_point
	segment2.end_point = $Point2.global_position
	segment.add_child(segment2)
	segment2.make_mesh()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
