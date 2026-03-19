extends Node3D
class_name Map
signal chest_effect_triggered(effect: ChestEffectBase)
@export var _rooms_node: Node3D
@export var floor_generator: FloorGenerator
@export var player: Player

func _on_chest_effect(effect: ChestEffectBase) -> void:
	chest_effect_triggered.emit(effect)

func _ready() -> void:
	if floor_generator != null:
		_generate_floor()

func _generate_floor() -> void:
	for room in _rooms_node.get_children():
		room.queue_free()
	var rooms := floor_generator.generate_map()
	
	for lane in rooms.rooms:
		for room in lane:
			_rooms_node.add_child(room)

	var chests := get_tree().get_nodes_in_group("chests")
	for chest: Chest in chests:
		chest.chest_entered.connect(_on_chest_effect)
	
