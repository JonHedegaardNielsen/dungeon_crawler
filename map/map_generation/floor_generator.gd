extends Resource
class_name FloorGenerator
@export var room_uids: Array[PackedScene] = []
var floor_size := 5
var room_size := 32.0
func generate_map() -> Array[Array]:
	var next_room_position := Vector3.ZERO
	var rooms: Array[Array] = [[], [], [], [], []]
	for lane in rooms:
		next_room_position.x += room_size
		for i in range(floor_size):
			next_room_position.z += room_size
			var room_uid_index = randf_range(0, room_uids.size())
			var room_instance: Node3D = room_uids[room_uid_index].instantiate()
			room_instance.position = next_room_position
			rooms[i].append(room_instance)
		next_room_position.z = 0
	return rooms
