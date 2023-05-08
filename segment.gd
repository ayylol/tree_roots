extends Node3D
class_name Segment

var extend_dir = Vector3(0,0,0)

var segment_scene = preload("res://segment.tscn")

func init(pos: Vector3) -> void:
	global_position = pos
	if (has_node("Line")):
		var old_line = get_node("Line")
		old_line.name = "OldLine"
		old_line.queue_free()
	var l = line(to_local(get_parent().global_position),Vector3(0,0,0))
	l.name = "Line"
	add_child(l)
	
func extend_to(pos: Vector3)-> Segment:
	var new_segment = segment_scene.instantiate()
	add_child(new_segment)
	new_segment.init(pos)
	return new_segment

func extend(segment_length: float)-> Segment:
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
	
func decimate():
	pass
	# Get list of nodes in decimate range
	# Sum their positions
	# Add children of decimated nodes to this node, re-init to get correct position relative to parent
	# free decimated node
	# average position and reinitialize this node's position
	
	
func traverse_segments(pre: String, post:String, depth:int):
	var cull = false
	if(has_method(pre)):
		cull = call(pre, depth)
	if(!cull):
		pass
		#for 
	if(has_method(post)): call(post, depth)

