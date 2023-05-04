extends Node3D

func is_inside()-> bool:
	var params = PhysicsPointQueryParameters3D.new()
	params.position = global_position
	params.collision_mask = 0b1000
	var result = get_world_3d().direct_space_state.intersect_point(params)
	return !result.is_empty()
