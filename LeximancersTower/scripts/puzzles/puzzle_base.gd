## PuzzleBase — Base class for all puzzle logic nodes.
class_name PuzzleBase extends Node

signal puzzle_activated
signal puzzle_solved
signal puzzle_reset

@export var puzzle_id: String = ""
@export var floor_number: int = 1
@export var dependencies: Array[String] = []

func _ready() -> void:
	if not puzzle_id.is_empty():
		var pm := get_node("/root/PuzzleManager") as Node
		if pm:
			pm.register_puzzle(puzzle_id, floor_number, dependencies)
			if pm.is_solved(puzzle_id):
				_on_already_solved()

func activate() -> void:
	var pm := get_node("/root/PuzzleManager") as Node
	if pm and not pm.is_unlocked(puzzle_id):
		return
	puzzle_activated.emit()

func solve() -> void:
	if not puzzle_id.is_empty():
		var pm := get_node("/root/PuzzleManager") as Node
		if pm:
			pm.mark_solved(puzzle_id)
	puzzle_solved.emit()

func reset_puzzle() -> void:
	puzzle_reset.emit()

func _on_already_solved() -> void:
	pass
