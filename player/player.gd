extends CharacterBody3D
class_name Player

@export var weapon: MeleeWeapon:
	set(value):
		if weapon_mesh != null:
			weapon_mesh.mesh = value.mesh
		weapon = value
@export var speed_curve: Curve
@export var _health_module: BasicHealthModule
@export var rotating_body: Node3D
@export var animation_player: AnimationPlayer
const SPEED = 5.0
signal coin_collected(new_amount: int, amount_added: int)
var coins: int = 0
var time_ran: float = 0.0
var _camera: Camera3D
@export var orbit_speed: float = 1.0
@export var orbit_radius: float = 5.0
@export var weapon_mesh: MeshInstance3D
@export var attack_hitbox_spawn_point: Node3D
signal health_change(int)
var _current_melee_weapon_hitbox: HitBox
var angle := 90.0
func _ready() -> void:
	_camera = get_viewport().get_camera_3d()
	_rotate_camera(0, 1)
	weapon_mesh.mesh = weapon.mesh
	animation_player.animation_finished.connect(_on_attack_animation_finished)

func handle_movement(delta: float) -> void:
	var input_dir := Input.get_vector("move_right", "move_left", "move_down", "move_up")
	var direction := (_camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		time_ran += delta
		var mult = speed_curve.sample(time_ran)
		velocity.x = direction.x * SPEED * mult
		velocity.z = direction.z * SPEED * mult
		if not animation_player.is_playing():
			animation_player.play("Rig_Medium_MovementBasic/Walking_A")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		time_ran = 0.0
		if not animation_player.is_playing():
			animation_player.play("Rig_Medium_General/Idle_A")
	move_and_slide()

func _rotate_camera(direction: float, delta: float) -> void:
	angle += 2.0 * delta * direction
	var offset = Vector3(cos(angle) * orbit_radius, 0.0, sin(angle) * orbit_radius) * 0.9
	var target_position := global_position
	target_position.y = _camera.global_position.y
	_camera.global_position = target_position + offset
	var old_y_direction := _camera.rotation.x
	var position_to_look_at := global_position
	position_to_look_at.y += 2
	_camera.look_at(position_to_look_at, Vector3.UP)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("rotate_camera_right"):
		_rotate_camera(-1, delta)
	if Input.is_action_pressed("rotate_camera_left"):
		_rotate_camera(1, delta)
	handle_movement(delta)
	var pos := get_mouse_ray_hit()
	
	if pos.has("position"):
		var target_pos: Vector3 = pos["position"]
		target_pos.y = global_position.y
		rotating_body.look_at(target_pos, Vector3.UP)
		rotating_body.global_rotation_degrees.y += 180.0
	
	if Input.is_action_pressed("attack"):
		attack()

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
	if camera == null:
		return {}
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_end := ray_origin + camera.project_ray_normal(mouse_pos) * 1000.0
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = 128
	query.collide_with_areas = true   # include Area3D nodes
	query.collide_with_bodies = true  # include RigidBody3D, StaticBody3D, etc.
	var space_state = get_world_3d().direct_space_state
	return space_state.intersect_ray(query)

func attack() -> void:
	if _current_melee_weapon_hitbox != null:
		return
	var hit_box: HitBox = weapon.hitbox.instantiate()
	hit_box.set_collision_mask_value(5,true)
	hit_box.hit_target.connect(_on_hit_target)
	animation_player.play("Rig_Medium_General/Throw", -1, weapon.attack_speed)
	_current_melee_weapon_hitbox = hit_box
	attack_hitbox_spawn_point.add_child(hit_box)

func _on_attack_animation_finished(animation_name: StringName) -> void:
	if animation_name == "Rig_Medium_General/Throw":
		if _current_melee_weapon_hitbox != null:
			_current_melee_weapon_hitbox.queue_free()
			_current_melee_weapon_hitbox = null

func _on_hit_target(body: PhysicsBody3D) -> void:
	if body is MeleeEnemy:
		body.take_damage(weapon.damage)

func take_damage(amount: int) -> void:
	_health_module.take_damage(amount)
	health_change.emit(_health_module.health)

func _die() -> void:
	queue_free()

func get_health() -> int:
	return _health_module.health

func get_max_health() -> int:
	return _health_module.max_health
