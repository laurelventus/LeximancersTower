## Floor1Entrance — The Entrance Hall (1F).
## Tutorial floor: teaches movement, interaction, spell casting, and puzzle solving.

extends Node2D

@onready var _player_spawn: Marker2D = $PlayerSpawn
@onready var _push_stone: Node = $PushStone
@onready var _torch: Node = $Torch
@onready var _rune_door: Node = $RuneDoor
@onready var _owly: Node = $Owly


func _ready() -> void:
	_setup_puzzles()
	_spawn_player()

func _setup_puzzles() -> void:
	var pm := get_node("/root/PuzzleManager") as Node
	pm.register_puzzle("floor1_push_stone", 1, [])
	pm.register_puzzle("floor1_light_torch", 1, [])
	pm.register_puzzle("floor1_main_door", 1, ["floor1_push_stone", "floor1_light_torch"])
	
	# Connect signals via duck typing
	if _push_stone and _push_stone.has_signal("interacted"):
		_push_stone.interacted.connect(_on_stone_pushed)
	if _torch and _torch.has_signal("spell_success"):
		_torch.spell_success.connect(_on_torch_lit)
	
	if pm.is_solved("floor1_push_stone"):
		_push_stone.queue_free()
	if pm.is_solved("floor1_light_torch"):
		_torch.queue_free()
	if pm.is_solved("floor1_main_door"):
		_rune_door.queue_free()

func _spawn_player() -> void:
	var player := CharacterBody2D.new()
	player.name = "Player"
	var player_script := load("res://scripts/player/player.gd") as Script
	player.set_script(player_script)
	
	var sprite := Sprite2D.new()
	sprite.name = "Sprite2D"
	var rect := ColorRect.new()
	rect.size = Vector2(24, 24)
	rect.color = Color.SKY_BLUE
	sprite.add_child(rect)
	sprite.position = Vector2(-12, -12)
	player.add_child(sprite)
	
	var anim := AnimationPlayer.new()
	anim.name = "AnimationPlayer"
	player.add_child(anim)
	
	var ray := RayCast2D.new()
	ray.name = "InteractRay"
	ray.target_position = Vector2(0, 32)
	player.add_child(ray)
	
	var area := Area2D.new()
	area.name = "InteractArea"
	var area_col := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 32
	area_col.shape = circle
	area.add_child(area_col)
	player.add_child(area)
	
	var collision := CollisionShape2D.new()
	var caps := CapsuleShape2D.new()
	caps.radius = 10
	caps.height = 20
	collision.shape = caps
	player.add_child(collision)
	
	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.enabled = true
	camera.make_current()
	player.add_child(camera)
	
	if _player_spawn:
		player.global_position = _player_spawn.global_position
	else:
		player.position = Vector2(240, 200)
	
	add_child(player)

func _on_stone_pushed() -> void:
	print("[1F] Stone pushed aside!")
	var pm := get_node("/root/PuzzleManager") as Node
	pm.mark_solved("floor1_push_stone")
	var key_fragment := _create_spell_fragment("spell_key", "KEY", $SpellFragments.position + Vector2(0, -20))
	add_child(key_fragment)

func _on_torch_lit(spell_id: String) -> void:
	print("[1F] Torch lit with %s!" % spell_id)
	var pm := get_node("/root/PuzzleManager") as Node
	pm.mark_solved("floor1_light_torch")
	if _torch:
		_torch.modulate = Color.ORANGE

func _create_spell_fragment(spell_id: String, word: String, pos: Vector2) -> Node2D:
	var container := Area2D.new()
	container.name = "Fragment_" + spell_id
	container.position = pos
	
	var col := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 12
	col.shape = circle
	container.add_child(col)
	
	var sprite := Sprite2D.new()
	var rect := ColorRect.new()
	rect.size = Vector2(16, 16)
	rect.color = Color.GOLD
	sprite.add_child(rect)
	sprite.position = Vector2(-8, -8)
	container.add_child(sprite)
	
	var label := Label.new()
	label.text = word
	label.add_theme_font_size_override("font_size", 8)
	label.position = Vector2(-20, -24)
	container.add_child(label)
	
	container.body_entered.connect(_on_spell_fragment_collected.bind(spell_id, word, container))
	
	return container

func _on_spell_fragment_collected(spell_id: String, word: String, fragment: Node2D, _body: Node2D) -> void:
	if _body.name == "Player":
		var sb := get_node("/root/SpellBook") as Node
		sb.add_spell(spell_id, word, 0)
		var tween := fragment.create_tween()
		tween.tween_property(fragment, "scale", Vector2(1.5, 1.5), 0.15)
		tween.tween_property(fragment, "modulate:a", 0.0, 0.3)
		tween.tween_callback(fragment.queue_free)
