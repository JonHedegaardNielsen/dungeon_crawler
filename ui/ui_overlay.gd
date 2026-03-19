extends CanvasLayer
class_name UIOverlay

const CHEST_EFFECT_MESSAGE_SCENE = preload("uid://75w260ibs5sg")
@export var _player_heath_bar: ProgressBar
@export var coin_label: Label
@export var middle_position: Control
@export var _health_label: Label
@export var _player:Player
func _ready() -> void:
	coin_label.text = "Coins: 0"
	_player_heath_bar.max_value = _player.get_max_health()
	_player_heath_bar.value = _player.get_health()
	_player.health_change.connect(_on_player_health_change)

func get_coin(new_amount: int, amount_added: int) -> void:
	coin_label.text = "Coins: " + str(new_amount)

func display_chest_effect_message(chest_effect: ChestEffectBase, player: Player) -> void:
	var message: ChestRewardMessage = CHEST_EFFECT_MESSAGE_SCENE.instantiate()
	message.effect = chest_effect
	message.player = player
	middle_position.add_child(message)
	get_tree().paused = true

func _on_player_health_change(health: int):
	_player_heath_bar.value = health
	_health_label.text = str(health)
