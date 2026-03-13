extends Node3D

@export var map: Map
@export var ui_overlay: UIOverlay
@export var player: Player

func _ready() -> void:
	var chests: Array[Node] = get_tree().get_nodes_in_group("chests")
	for chest in chests:
		if chest is Chest:
			chest.chest_entered.connect(_on_chest_effect_triggered)

func _on_chest_effect_triggered(effect: ChestEffectBase) -> void:
	ui_overlay.display_chest_effect_message(effect, player)
	
