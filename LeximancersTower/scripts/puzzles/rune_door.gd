## RuneDoor — 1F main puzzle: arrange 3 runes in order.
extends Node2D

signal door_opened

@export var correct_order: Array = ["spell_open", "spell_light", "spell_key"]
@export var puzzle_id: String = "floor1_main_door"

var _inserted_runes: Array = []
var _solved: bool = false

func _ready() -> void:
	var pm := get_node("/root/PuzzleManager") as Node
	if pm and pm.is_solved(puzzle_id):
		_solved = true
		queue_free()

func insert_rune(spell_id: String) -> void:
	if _solved:
		return
	_inserted_runes.append(spell_id)
	print("[RuneDoor] Rune inserted: %s (slot %d)" % [spell_id, _inserted_runes.size()])
	
	# Check if we have 3 runes inserted
	if _inserted_runes.size() >= 3:
		_check_solution()

func _check_solution() -> void:
	var correct := true
	for i in range(3):
		if i >= _inserted_runes.size() or _inserted_runes[i] != correct_order[i]:
			correct = false
			break
	
	if correct:
		_solved = true
		var pm := get_node("/root/PuzzleManager") as Node
		if pm:
			pm.mark_solved(puzzle_id)
		print("[RuneDoor] Door opens!")
		door_opened.emit()
		_open_door()
	else:
		print("[RuneDoor] Wrong order! Resetting...")
		_inserted_runes.clear()
		_shake_door()

func _open_door() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback(queue_free)

func _shake_door() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position:x", position.x + 4.0, 0.05)
	tween.tween_property(self, "position:x", position.x - 4.0, 0.05)
	tween.tween_property(self, "position:x", position.x, 0.05)

func on_interact() -> void:
	if _solved:
		return
	
	# Open a rune selection UI (placeholder: just check spell book)
	var sb := get_node("/root/SpellBook") as Node
	var spells = sb.get_all_spells() if sb else []
	
	print("[RuneDoor] Available spells: %s" % str(spells))
	# The actual selection happens through the spell book UI
	# For now, just print available spells for debugging
