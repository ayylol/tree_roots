extends Node3D

@onready var neighborhoods = $DistanceNeighborhoods

func init(max_dist: float, destroy_dist: float):
	var i = 0
	for n in neighborhoods.get_children():
		var d = (destroy_dist+(i*(max_dist-destroy_dist)/(neighborhoods.get_child_count()-1)))*2
		n.scale=Vector3(d,d,d)
		i+=1

func is_inside()-> bool:
	var params = PhysicsPointQueryParameters3D.new()
	params.position = global_position
	params.collision_mask = 0b1000
	var result = get_world_3d().direct_space_state.intersect_point(params)
	return !result.is_empty()

func get_closest():
	var space3d = get_world_3d().direct_space_state
	var params = PhysicsShapeQueryParameters3D.new()
	params.collide_with_areas=true
	params.collide_with_bodies=false
	params.collision_mask = 0b1000_0000
	var i = 0
	for n in neighborhoods.get_children():
		params.shape = n.get_child(0).shape
		params.transform = n.global_transform
		var result = space3d.intersect_shape(params)
		if (!result.is_empty()):
			if(i==0):
				queue_free()
			var closest = result[0].collider.get_parent()
			var min_dist2 = 1.79769e308
			# find closest	
			for c in result:
				var dist2 = (c.collider.global_position-global_position).length_squared()
				if (dist2<min_dist2):
					closest = c.collider.get_parent()
					min_dist2=dist2
			return closest
		i+=1
	return null
