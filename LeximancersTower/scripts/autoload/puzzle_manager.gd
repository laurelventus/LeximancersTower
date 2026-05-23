## PuzzleManager — Tracks puzzle states per floor.
## Autoload: each puzzle has { id, level, is_solved, attempts }.

extends Node

signal puzzle_solved(puzzle_id: String)
signal puzzle_attempted(puzzle_id: String, success: bool)
signal floor_completed(level: int)

var _puzzles: Dictionary = {}

func register_puzzle(puzzle_id: String, level: int, dependencies: Array = []) -> void:
	if not _puzzles.has(puzzle_id):
		_puzzles[puzzle_id] = {
			"level": level,
			"is_solved": false,
			"attempts": 0,
			"dependencies": dependencies.duplicate()
		}

func submit_solution(puzzle_id: String, solution) -> bool:
	if not _puzzles.has(puzzle_id):
		return false
	var puzzle = _puzzles[puzzle_id]
	puzzle.attempts += 1
	return true

func mark_solved(puzzle_id: String) -> void:
	if not _puzzles.has(puzzle_id):
		return
	_puzzles[puzzle_id].is_solved = true
	puzzle_solved.emit(puzzle_id)
	puzzle_attempted.emit(puzzle_id, true)
	print("[PuzzleManager] Solved: %s" % puzzle_id)
	var level: int = _puzzles[puzzle_id].level
	if is_floor_complete(level):
		floor_completed.emit(level)
		print("[PuzzleManager] Level %d complete!" % level)

func is_solved(puzzle_id: String) -> bool:
	return _puzzles.get(puzzle_id, {}).get("is_solved", false)

func is_unlocked(puzzle_id: String) -> bool:
	if not _puzzles.has(puzzle_id):
		return false
	for dep in _puzzles[puzzle_id].dependencies:
		if not is_solved(dep):
			return false
	return true

func get_unsolved_on_floor(level: int) -> Array:
	var result: Array = []
	for id in _puzzles:
		if _puzzles[id].level == level and not _puzzles[id].is_solved:
			result.append(id)
	return result

func is_floor_complete(level: int) -> bool:
	for id in _puzzles:
		if _puzzles[id].level == level and not _puzzles[id].is_solved:
			return false
	return true

func reset() -> void:
	_puzzles.clear()

func get_save_data() -> Dictionary:
	return {"puzzles": _puzzles.duplicate(true)}

func load_save_data(data: Dictionary) -> void:
	_puzzles = data.get("puzzles", {})
