extends StaticBody3D

@export var max_attractors: int = 500

var num_attractors = 0

var attractor_scene = preload("res://attractor_point.tscn")

@onready var max_extent = Vector3(1,1,1)*-1.79769e308
@onready var min_extent = Vector3(1,1,1)*1.79769e308
@onready var SpawnArea = $SpawnArea
@onready var PointsParent = $PointsParent

func _ready():
	for point_local in SpawnArea.shape.points:
		var point = SpawnArea.to_global(point_local)
		
		max_extent.x = maxf(point.x,max_extent.x)
		max_extent.y = maxf(point.y,max_extent.y)
		max_extent.z = maxf(point.z,max_extent.z)
		
		min_extent.x = minf(point.x,min_extent.x)
		min_extent.y = minf(point.y,min_extent.y)
		min_extent.z = minf(point.z,min_extent.z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	while num_attractors < max_attractors:
		var attractor = attractor_scene.instantiate()
		attractor.position = to_local(Vector3(randf_range(min_extent.x,max_extent.x),randf_range(min_extent.y,max_extent.y),randf_range(min_extent.z,max_extent.z)))
		PointsParent.add_child(attractor)
		if(attractor.is_inside()):
			num_attractors+=1
		else:
			print("yep")
			attractor.free()
