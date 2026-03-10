extends Node3D
class_name Map
signal chest_effect_triggered(effect: ChestEffectBase)
@export var chests_node: Node3D

# func _ready() -> void:
# 	for chest in chests_node.get_children():
# 		if chest is Chest:
# 			chest.chest_effect.connect(_on_chest_effect)
func _on_chest_effect(effect: ChestEffectBase) -> void:
	chest_effect_triggered.emit(effect)
