extends Area3D
class_name Chest

@export var chest_effect: ChestEffectBase

signal chest_entered(effect: ChestEffectBase)
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		chest_entered.emit(chest_effect)
