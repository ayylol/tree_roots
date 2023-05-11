extends Node3D
class_name Segment

var extend_dir = Vector3(0,0,0)

var segment_scene = preload("res://segment.tscn")

@onready var segments_parent = $SegmentsParent

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
	# Collide pos with world
#	var params = PhysicsPointQueryParameters3D.new()
#	params.position = pos
#	params.collision_mask = 0b1000_0000
#	var result = get_world_3d().direct_space_state.intersect_point(params)
#	if(!result.is_empty()):
#		print(result)
#		print("COLLIDING!!!")
#		return null
	var new_segment = segment_scene.instantiate()
	segments_parent.add_child(new_segment)
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

func segments_to_string(transform: Transform3D)->String:
	var pos = transform*global_position
	var string: String = "( " + String.num(pos.x) + " " + String.num(pos.z) + " " + String.num(pos.y) + " ) "
	var i = 0
	for segment in segments_parent.get_children():
		var is_last = i==segments_parent.get_child_count()-1
		var pre = "" if is_last else "[ "
		var post= "" if is_last else "] "
		string += pre + segment.segments_to_string(transform) + post
		i+=1
	return string

func write_tree_to_file(transform: Transform3D):
	var file = FileAccess.open("res://roots.data", FileAccess.WRITE)
	file.store_string(segments_to_string(transform))
	print("Outputted to file")
