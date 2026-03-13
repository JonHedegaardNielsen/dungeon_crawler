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
		# _handle_rotation(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	var pos := get_mouse_ray_hit()

	if pos.has("position"):
		print(pos)
		var target_pos: Vector3 = pos["position"]
		target_pos.y = global_position.y  # lock to same Y so only rotates horizontally
		rotating_body.look_at(target_pos, Vector3.UP)
		rotating_body.global_rotation_degrees.y += 180.0
		# rotating_body.global_rotation.y = pos["position"].y

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

func apply_chest_effect(effect: ChestEffectBase) -> void:
	if effect is AddMoneyEffect:
		add_coins(effect.amount_to_add)


func get_mouse_ray_hit() -> Dictionary:
	var camera := get_viewport().get_camera_3d()
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_end := ray_origin + camera.project_ray_normal(mouse_pos) * 1000.0
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	# query.collision_mask = 8
	query.collide_with_areas = true   # include Area3D nodes
	query.collide_with_bodies = true  # include RigidBody3D, StaticBody3D, etc.
	var space_state = get_world_3d().direct_space_state
	return space_state.intersect_ray(query)
