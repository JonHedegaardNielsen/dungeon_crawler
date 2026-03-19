extends Resource
class_name FloorGenerator
@export var _room_scenes: Array[PackedScene] = []
@export var _starter_room_scene: PackedScene
const floor_size := 5
const room_size := 12
var _has_picked_starter_room: bool

class FloorData:
	var rooms: Array[Array]
	var starting_room: Room
	func _init(rooms: Array[Array], starting_room: Room) -> void:
		self.rooms = rooms
		self.starting_room = starting_room

func generate_map() -> FloorData:
	var starting_room: Node3D = _starter_room_scene.instantiate()
	var start_position := Vector2i(randi_range(0, floor_size), randi_range(0, floor_size))
	var next_room_position := Vector3.ZERO
	var rooms: Array[Array] = [[], [], [], [], []]
	for i in range(0, len(rooms)):
		next_room_position.x += room_size
		for j in range(floor_size):
			var room_instance: Node3D
			if start_position.x == j and start_position.y == i:
				room_instance = starting_room
			else:
				next_room_position.z += room_size
			var room_uid_index := randi_range(0, _room_scenes.size()) -1
			room_instance = _room_scenes[room_uid_index].instantiate()
			room_instance.position = next_room_position
			rooms[i].append(room_instance)
		next_room_position.z = 0
	return FloorData.new(rooms, starting_room)
