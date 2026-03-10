class_name AddMoneyEffect
extends ChestEffectBase

@export var amount_to_add: int = 1
func _init() -> void:
	effect_description = "Add Money: " + str(amount_to_add)
