extends StaticBody3D

@export var max_attractors: int = 100
@export var destroy_dist: float = 1
@export var segment_length: float = 0.5
@export var max_dist_factor: float = 1.0
@export var t: Transform3D = Transform3D()

var max_extent = Vector3(1,1,1)*-1.79769e308
var min_extent = Vector3(1,1,1)*1.79769e308
var max_dist = 0

var  sca_on = false
var counter = 0

var attractor_scene = preload("res://attractor_point.tscn")
var current_area = null

@onready var SpawnArea = $SpawnArea
@onready var SpawnArea2 = $SpawnArea2
@onready var PointsParent = $PointsParent
@onready var StartSegment = $SegmentsParent/Segment


func _ready():
	StartSegment.init($SegmentsParent.global_position)
	# Find the extents of the Bounds
	set_spawnarea(SpawnArea)
	make_attractors(max_attractors)
	set_spawnarea(SpawnArea2)

func set_spawnarea(shape):
	if (current_area != null): current_area.disabled = true
	current_area = shape
	shape.disabled = false
	
	max_extent = Vector3(1,1,1)*-1.79769e308
	min_extent = Vector3(1,1,1)*1.79769e308
	for point_local in shape.shape.points:
		var point = shape.to_global(point_local)
		max_extent.x = maxf(point.x,max_extent.x)
		max_extent.y = maxf(point.y,max_extent.y)
		max_extent.z = maxf(point.z,max_extent.z)
		min_extent.x = minf(point.x,min_extent.x)
		min_extent.y = minf(point.y,min_extent.y)
		min_extent.z = minf(point.z,min_extent.z)
	
	var extent = abs(max_extent-min_extent)
	max_dist = maxf(maxf(extent.x,extent.y),extent.z)

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
		StartSegment.write_tree_to_file(t)
	if(Input.is_action_just_pressed("StepSCA")):
		sca_step()
	if(Input.is_action_just_pressed("AddAttractor")):
		make_attractors(10)

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
			attractor.init(max_dist*max_dist_factor,destroy_dist)
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
		if(!to_extend.has(c)): 
			to_extend[c]=[p]
		else:
			to_extend[c].append(p)
		# Add normalized direction to node
		c.extend_dir += (p.global_position-c.global_position).normalized()
		# Keep track of the node that an attractor last extended
		p.last_influenced = c
		
	# For each node influenced extend in direction sum multiplied by segment length
	if(to_extend.is_empty()):
		sca_on = false
		print("None to extend")
	for n in to_extend.keys():
		if(to_extend[n].size()==2 and to_extend[n][0].last_influenced == n and to_extend[n][1].last_influenced == n):
			n.extend_dir = (to_extend[n][0].global_position-n.global_position).normalized()
		#print(n.global_position," closest to ", to_extend[n], " nodes")
		n.extend(segment_length)
	#print("Done SCA Step\n")
	counter+=1


