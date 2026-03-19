extends Node3D
class_name Room

@export var _middle_position_node: Node3D 
@export var navigation: NavigationRegion3D

func get_middle_position() -> Vector3:
	return _middle_position_node.global_position
