extends Node3D

var extend_dir = Vector3(0,0,0)

var segment_scene = preload("res://segment.tscn")

func init(pos: Vector3) -> void:
	global_position = pos
	var l = line(to_local(get_parent().global_position),Vector3(0,0,0))
	add_child(l)
	
func extend_to(pos: Vector3)-> Node3D:
	var new_segment = segment_scene.instantiate()
	add_child(new_segment)
	new_segment.init(pos)
	return new_segment

func extend(segment_length: float)-> Node3D:
	var to = global_position+extend_dir.normalized()*segment_length
	extend_dir = Vector3(0,0,0)
	return extend_to(to)

func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	return mesh_instance
