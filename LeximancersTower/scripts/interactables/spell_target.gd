## SpellTarget — Object that responds to a specific spell.
## Plays success/failure animations. Emits signal when solved.
class_name SpellTarget extends InteractableBase

signal spell_success(spell_id: String)
signal spell_failure(spell_id: String)

@export var correct_spell: String = ""
@export var puzzle_id: String = ""
@export var destroy_on_success: bool = true

var _solved: bool = false

func on_interact() -> void:
	if _solved:
		return
	
	var pm := get_node("/root/PuzzleManager") as Node
	if pm and not puzzle_id.is_empty() and not pm.is_unlocked(puzzle_id):
		print("[SpellTarget] Puzzle %s not yet unlocked" % puzzle_id)
		return
	
	# Spell selection happens via UI — this is triggered externally

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

func _success_animation() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)

func _failure_animation() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position:x", position.x + 4.0, 0.05)
	tween.tween_property(self, "position:x", position.x - 4.0, 0.05)
	tween.tween_property(self, "position:x", position.x, 0.05)
