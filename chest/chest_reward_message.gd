extends Control
class_name ChestRewardMessage

var player: Player
@export var message_label: Label
var effect: ChestEffectBase

func close() -> void:
	queue_free()
	player.apply_chest_effect(effect)
	get_tree().paused = false

func _ready() -> void:
	message_label.text = effect.effect_description
