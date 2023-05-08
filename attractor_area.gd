extends StaticBody3D

@export var max_attractors: int = 100
@export var destroy_dist: float = 1
@export var segment_length: float = 0.5

var max_extent = Vector3(1,1,1)*-1.79769e308
var min_extent = Vector3(1,1,1)*1.79769e308
var max_dist = 0

var  sca_on = false
var counter = 0

var attractor_scene = preload("res://attractor_point.tscn")

@onready var SpawnArea = $SpawnArea
@onready var PointsParent = $PointsParent
@onready var StartSegment = $SegmentsParent/Segment


func _ready():
	StartSegment.init($SegmentsParent.global_position)
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

func _physics_process(_delta):
	if(sca_on): 
		sca_step()
	
func _unhandled_input(_event):
	if (Input.is_action_just_pressed("ClearPoints")):
		clear_attractors()
	if(Input.is_action_just_pressed("ToggleSCA")):
		sca_on = !sca_on
	if(Input.is_action_just_pressed("Decimate")):
		pass
	if(Input.is_action_just_pressed("Output")):
		pass
	if(Input.is_action_just_pressed("StepSCA")):
		sca_step()


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
	print("Starting SCA Step: ", counter)
	var to_extend = {}
	# Get closest point to each attractor
	for p in PointsParent.get_children():
		var c = p.get_closest()
		if c == null: continue
		to_extend[c]=0
		# Add normalized direction to node
		c.extend_dir += (p.global_position-c.global_position).normalized()#*randf_range(0.1,1.0)
		
	# For each node influenced extend in direction sum multiplied by segment length
	for n in to_extend.keys():
		print(n.global_position)
		n.extend(segment_length)
	print("Done SCA Step\n")
	counter+=1


