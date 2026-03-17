
const ROOM_UIDS: Array[String] = []
var floor_size := 5

func generate_map() -> Array[Array]:
	var rooms: Array[Array] = [[], [], [], [], []]
	for lane in rooms:
		for i in range(floor_size):
			var room_uid_index = randf_range(0, ROOM_UIDS.size())
			var room_instance: Node3D = load(ROOM_UIDS[room_uid_index]).instantiate()
			rooms[i].append(room_instance)

	return rooms
