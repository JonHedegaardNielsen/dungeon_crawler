extends CharacterBody3D
class_name Projectile

var target: Vector3
var _speed: float
var damage: int
func fire(mousepos: Vector3, speed: float):
	target = mousepos
	_speed = speed

func _physics_process(delta):
	var direction = (target - global_position)
	if direction.length() > 0.1:
		direction.y = 0  # keep it flat
		direction = direction.normalized()
		velocity.x = direction.x * _speed
		velocity.z = direction.z * _speed
	else:
		velocity = Vector3.ZERO
		queue_free()  # delete projectile when it arrives
	move_and_slide()

func _on_hit(body):
	if body is MeleeEnemy:
		body.take_damage(damage)
	queue_free()
