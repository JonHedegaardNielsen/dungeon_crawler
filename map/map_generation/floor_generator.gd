extends Resource
class_name FloorGenerator
@export var _room_scenes: Array[PackedScene] = []
@export var _starter_room_scene: PackedScene
@export var _boss_room_scene: PackedScene
const floor_size := 5
const room_size := 12

class FloorData:
	var rooms: Array[Array]
	var starting_room: Room
	var boss_room: Room
	func _init(rooms_value: Array[Array], _starting_room_value: Room, _boss_room_value: Room) -> void:
		self.rooms = rooms_value
		self.starting_room = _starting_room_value
		self.boss_room = _boss_room_value

func generate_map() -> FloorData:
	var rooms: Array[Array] = [[], [], [], [], []]
	var starting_room: Node3D = _starter_room_scene.instantiate()
	var boss_room: Node3D = _boss_room_scene.instantiate()
	var start_position := Vector2i(randi_range(0, floor_size - 1) , randi_range(0, rooms.size() - 1))
	var boss_room_position := Vector2i(randi_range(0, floor_size - 1) , randi_range(0, rooms.size() - 1))
	var next_room_position := Vector3.ZERO
	for i in range(0, len(rooms)):
		next_room_position.x += room_size
		for j in range(floor_size):
			var room_instance: Node3D
			if start_position == Vector2i(j, i):
				room_instance = starting_room
			elif boss_room_position == Vector2i(j, i):
				room_instance = boss_room
			else:
				var room_uid_index := randi_range(0, _room_scenes.size()) -1
				room_instance = _room_scenes[room_uid_index].instantiate()
			next_room_position.z += room_size
			room_instance.position = next_room_position
			rooms[i].append(room_instance)
		next_room_position.z = 0
	print(boss_room_position)
	print(start_position)
	return FloorData.new(rooms, starting_room, boss_room)
