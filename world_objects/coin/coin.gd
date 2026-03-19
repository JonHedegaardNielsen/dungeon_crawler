extends Node3D
class_name Coin

@export var area: Area3D
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.add_coins(1)
		queue_free()
