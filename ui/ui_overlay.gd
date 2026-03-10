extends CanvasLayer

@export var coin_label: Label

func _ready() -> void:
	coin_label.text = "Coins: 0"

func get_coin(new_amount: int, amount_added: int) -> void:
	coin_label.text = "Coins: " + str(new_amount)
