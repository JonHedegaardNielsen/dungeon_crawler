extends Node
class_name EnemyHealthBar

@export var health_module: BasicHealthModule
@export var health_bar: ProgressBar
@export var health_bar_label: Label

func _ready() -> void:
	health_bar.max_value = health_module.max_health
	health_module.damage_taken.connect(_update_health_bar)

func _update_health_bar(amount: int) -> void:
	health_bar.value = health_module.health
	health_bar_label.text = str(health_module.health) + " / " + str(health_module.max_health)
