extends Control
class_name ChestRewardMessage

var message: String = ""
@export var message_label: Label

func close() -> void:
	queue_free()
	get_tree().paused = false

func _ready() -> void:
	message_label.text = message
