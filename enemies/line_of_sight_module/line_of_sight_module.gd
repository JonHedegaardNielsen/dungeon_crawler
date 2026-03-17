extends Node3D

@export var vision_area:Area3D
@export var vision_ray_cast: RayCast3D
signal player_detected(player: Player)
func _physics_process(delta: float) -> void:
	_update_vision()

func _update_vision() -> void:
	var overlaps := vision_area.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap is Player:
				var player_pos := overlap.global_position
				vision_ray_cast.look_at(player_pos)
				vision_ray_cast.global_rotation_degrees.x = 0
				vision_ray_cast.force_raycast_update()

				if vision_ray_cast.is_colliding():
					var collider := vision_ray_cast.get_collider()
					if collider is Player:
						player_detected.emit(collider)
