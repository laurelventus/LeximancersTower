## Player — Top-down 8-dir movement + interaction.
class_name Player extends CharacterBody2D

@export var move_speed: float = 80.0
@export var interact_range: float = 32.0

var _facing_direction: Vector2 = Vector2.DOWN
var _can_move: bool = true

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _interact_area: Area2D = $InteractArea
@onready var _interact_ray: RayCast2D = $InteractRay

func _ready() -> void:
	var gm := get_node("/root/GameManager") as Node
	if gm and gm.has_signal("game_phase_changed"):
		gm.game_phase_changed.connect(_on_game_phase_changed)

func _physics_process(_delta: float) -> void:
	var gm := get_node("/root/GameManager") as Node
	var current_phase = gm.game_phase if gm else 0
	
	if not _can_move or current_phase != 1:  # 1 = EXPLORING
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_dir != Vector2.ZERO:
		_facing_direction = input_dir.normalized()
		velocity = _facing_direction * move_speed
		_update_animation(input_dir)
	else:
		velocity = Vector2.ZERO
		_update_idle_animation()
	
	move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		_try_interact()

func _try_interact() -> void:
	if _interact_ray:
		_interact_ray.target_position = _facing_direction * interact_range
		_interact_ray.force_raycast_update()
		if _interact_ray.is_colliding():
			var obj = _interact_ray.get_collider()
			if obj and obj.has_method("on_interact"):
				obj.on_interact()
				return
	
	if _interact_area:
		var areas = _interact_area.get_overlapping_areas()
		for area in areas:
			if area.has_method("on_interact"):
				area.on_interact()
				return

func _update_animation(input_dir: Vector2) -> void:
	var dir_name := ""
	if abs(input_dir.x) > abs(input_dir.y):
		dir_name = "right" if input_dir.x > 0 else "left"
	else:
		dir_name = "down" if input_dir.y > 0 else "up"
	if _animation_player and _animation_player.has_animation("walk_" + dir_name):
		_animation_player.play("walk_" + dir_name)

func _update_idle_animation() -> void:
	var dir_name := ""
	if abs(_facing_direction.x) > abs(_facing_direction.y):
		dir_name = "right" if _facing_direction.x > 0 else "left"
	else:
		dir_name = "down" if _facing_direction.y > 0 else "up"
	if _animation_player and _animation_player.has_animation("idle_" + dir_name):
		_animation_player.play("idle_" + dir_name)

func _on_game_phase_changed(phase: String) -> void:
	_can_move = (phase == "EXPLORING")
