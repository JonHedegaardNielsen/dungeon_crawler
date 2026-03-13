extends CanvasLayer
class_name UIOverlay

const CHEST_EFFECT_MESSAGE_SCENE = preload("uid://75w260ibs5sg")
@export var coin_label: Label
@export var middle_position: Control

func _ready() -> void:
	coin_label.text = "Coins: 0"

func get_coin(new_amount: int, amount_added: int) -> void:
	coin_label.text = "Coins: " + str(new_amount)

func display_chest_effect_message(chest_effect: ChestEffectBase) -> void:
	var message: ChestRewardMessage = CHEST_EFFECT_MESSAGE_SCENE.instantiate()
	message.message = chest_effect.effect_description
	middle_position.add_child(message)
	get_tree().paused = true
