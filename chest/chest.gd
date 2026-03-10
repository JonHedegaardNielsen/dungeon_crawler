extends Area3D

@export var money_effect: ChestEffectBase
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		if money_effect is AddMoneyEffect:
			money_effect.apply_effect(body)
