extends Area3D
class_name HitBox

signal hit_target(enemy: PhysicsBody3D)

func _on_attack_hit(body: PhysicsBody3D) -> void:
	if body != null:
		hit_target.emit(body)
