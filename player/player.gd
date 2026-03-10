extends CharacterBody3D
class_name Player

@export var rotating_body: Node3D
const SPEED = 5.0
signal coin_collected(new_amount: int, amount_added: int)
var coins: int = 0
func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_right", "move_left", "move_down", "move_up")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		_handle_rotation(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func _handle_rotation( direction: Vector3):
	var degrees: float = 0
	if direction.x > 0:
		degrees = 90
	if direction.x < 0:
		degrees = 270
	if direction.z < 0:
		degrees = 180
	if direction.z > 0:
		degrees = 0
	
	rotating_body.rotation_degrees.y = degrees

func add_coins(amount: int = 1) -> void:
	coins += amount
	coin_collected.emit(coins, amount)
