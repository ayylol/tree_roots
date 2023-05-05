extends Node3D

@onready var neighborhoods = $DistanceNeighborhoods

func init(max_dist: float, destroy_dist: float):
	var i = 0
	for node in neighborhoods.get_children():
		var d = (destroy_dist+(i*(max_dist-destroy_dist)/(neighborhoods.get_child_count()-1)))*2
		node.scale=Vector3(d,d,d)
		i+=1

func is_inside()-> bool:
	var params = PhysicsPointQueryParameters3D.new()
	params.position = global_position
	params.collision_mask = 0b1000
	var result = get_world_3d().direct_space_state.intersect_point(params)
	return !result.is_empty()
