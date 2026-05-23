## SpellTarget — Object that responds to a specific spell.
## Extends Area2D directly (not InteractableBase) for headless compatibility.
extends Area2D

signal interacted
signal player_entered_range
signal player_exited_range
signal spell_success(spell_id: String)
signal spell_failure(spell_id: String)

@export var interaction_label: String = ""
@export var interaction_label_en: String = ""
@export var is_one_shot: bool = false
@export var requires_spell: String = ""
@export var correct_spell: String = ""
@export var puzzle_id: String = ""
@export var destroy_on_success: bool = true

var _used: bool = false
var _solved: bool = false

func _ready() -> void:
	if interaction_label_en.is_empty():
		interaction_label_en = interaction_label
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func on_interact() -> void:
	if _solved:
		return
	
	var pm := get_node("/root/PuzzleManager") as Node
	if pm and not puzzle_id.is_empty() and not pm.is_unlocked(puzzle_id):
		print("[SpellTarget] Puzzle %s not yet unlocked" % puzzle_id)
		return

func cast_spell(spell_id: String) -> bool:
	if _solved:
		return true
	if spell_id == correct_spell:
		_solved = true
		if not puzzle_id.is_empty():
			var pm := get_node("/root/PuzzleManager") as Node
			if pm:
				pm.mark_solved(puzzle_id)
		spell_success.emit(spell_id)
		if destroy_on_success:
			_success_animation()
		return true
	else:
		spell_failure.emit(spell_id)
		_failure_animation()
		return false

func _interact_effect() -> void:
	pass

func _success_animation() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)

func _failure_animation() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position:x", position.x + 4.0, 0.05)
	tween.tween_property(self, "position:x", position.x - 4.0, 0.05)
	tween.tween_property(self, "position:x", position.x, 0.05)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_entered_range.emit()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_exited_range.emit()
