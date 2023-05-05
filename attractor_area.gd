extends StaticBody3D

@export var max_attractors: int = 500
@export var destroy_dist: float = 0.4
@export var segment_length: float = 0.2

var max_extent = Vector3(1,1,1)*-1.79769e308
var min_extent = Vector3(1,1,1)*1.79769e308
var max_dist = 0

var attractor_scene = preload("res://attractor_point.tscn")

@onready var SpawnArea = $SpawnArea
@onready var PointsParent = $PointsParent
@onready var StartSegment = $SegmentsParent/Segment

func _ready():
	StartSegment.init($SegmentsParent.global_position)
	var new_segment = StartSegment.extend(Vector3(0,1.0,0.4))
	new_segment.name = "Segment2"
	new_segment = new_segment.extend(Vector3(0,1.0,0.3))
	new_segment.name = "Segment3"
	new_segment = StartSegment.extend(Vector3(1.0,1.5,-2.0))
	new_segment.name = "Segment4"
	# Find the extents of the Bounds
	for point_local in SpawnArea.shape.points:
		var point = SpawnArea.to_global(point_local)
		
		max_extent.x = maxf(point.x,max_extent.x)
		max_extent.y = maxf(point.y,max_extent.y)
		max_extent.z = maxf(point.z,max_extent.z)
		
		min_extent.x = minf(point.x,min_extent.x)
		min_extent.y = minf(point.y,min_extent.y)
		min_extent.z = minf(point.z,min_extent.z)
	
	var extent = abs(max_extent-min_extent)
	
	max_dist = maxf(maxf(extent.x,extent.y),extent.z)
	
	make_attractors(max_attractors)


func make_attractors(num: int):
	var num_made = 0
	while num_made < num:
		var attractor = attractor_scene.instantiate()
		attractor.position = to_local(
			Vector3(randf_range(min_extent.x,max_extent.x),
					randf_range(min_extent.y,max_extent.y),
					randf_range(min_extent.z,max_extent.z)))
		PointsParent.add_child(attractor)
		if(attractor.is_inside()):
			attractor.init(max_dist,destroy_dist)
			num_made+=1
		else:
			attractor.free()

func clear_attractors():
	for n in PointsParent.get_children():
		PointsParent.remove_child(n)
		n.queue_free()

func sca_step():
	pass
	# Get closest point to each attractor
	# Add normalized direction to node
	# For each node influenced extend in direction sum multiplied by segment length

func _on_timer_timeout():
	print("Calculating Closest")
	for a in PointsParent.get_children():
		var _x = a.get_closest()
#		if (x == null):
#			print("NONE")
#		else:
#			print(x.name)
