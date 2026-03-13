extends CharacterBody3D
class_name MeleeEnemy

@export var health_module: BasicHealthModule
var movement_speed: float = 2
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)
var attack_distance: float = 1.5
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@export var target: Node3D
var target_last_position: Vector3
@export var animation_player: AnimationPlayer
@export var rotating_body: Node3D
const ATTACK_HITBOX = preload("uid://b5ebnxdpjlwm6")
var _current_attack_hitbox: HitBox
@export var attack_hitbox_spawn_point: Node3D

func _ready():
	actor_setup.call_deferred()
	animation_player.animation_finished.connect(_on_attack_animation_finished)

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(target.global_position)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(_delta):
	if not is_instance_valid(target):
		return
	if  not target_last_position == target.global_position:
		set_movement_target(target.global_position)
	
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	rotating_body.look_at(next_path_position, Vector3.UP)
	global_rotation_degrees.y += 180.0
	if global_position.distance_to(target.global_position) <= attack_distance:
		_attack()
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

func _attack() -> void:
	if _current_attack_hitbox != null:
		return
	animation_player.play("Rig_Medium_General/Throw")
	var enemy_attack_hitbox: HitBox = ATTACK_HITBOX.instantiate()
	attack_hitbox_spawn_point.add_child(enemy_attack_hitbox)
	_current_attack_hitbox = enemy_attack_hitbox
	enemy_attack_hitbox.collision_mask = 2
	enemy_attack_hitbox.hit_target.connect(_target_hit)

func _on_attack_animation_finished(animation_name: String) -> void:
	if animation_name == "Rig_Medium_General/Throw" and _current_attack_hitbox != null:
		_current_attack_hitbox.queue_free()
		_current_attack_hitbox = null

func _target_hit(body: Player) -> void:
	if body != null:
		body.take_damage(3)

func take_damage(amount: int) -> void:
	health_module.take_damage(amount)

func _die() -> void:
	queue_free()
