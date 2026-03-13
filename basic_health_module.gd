extends Node
class_name BasicHealthModule

signal death()
var health: int = 10
var max_health: int = 10
signal damage_taken(amount: int)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		health = 0
		death.emit()
	damage_taken.emit(amount)

func heal(amount: int) -> void:
	health += amount
	if health > max_health:
		health = max_health
