## GameManager — Global game state and orchestration.
## Autoload: tracks current floor, overall progress, game phase.

extends Node

signal floor_changed(level: int)
signal game_phase_changed(phase: String)

enum Phase { MAIN_MENU, EXPLORING, DIALOGUE, PUZZLE, SPELL_BOOK, PAUSED }

var current_floor: int = 0
var game_phase: Phase = Phase.MAIN_MENU
var game_time_seconds: float = 0.0
var visited_floors: Array = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if game_phase != Phase.MAIN_MENU and game_phase != Phase.PAUSED:
		game_time_seconds += delta

func start_new_game() -> void:
	current_floor = 1
	game_time_seconds = 0.0
	visited_floors = [1]
	game_phase = Phase.EXPLORING

func set_floor(level: int) -> void:
	if level != current_floor:
		current_floor = level
		if not level in visited_floors:
			visited_floors.append(level)
		floor_changed.emit(level)

func set_phase(phase: Phase) -> void:
	game_phase = phase
	game_phase_changed.emit(Phase.keys()[phase])

func is_floor_unlocked(level: int) -> bool:
	return level <= current_floor or level in visited_floors

func get_save_data() -> Dictionary:
	return {
		"current_floor": current_floor,
		"visited_floors": visited_floors.duplicate(),
		"game_time_seconds": game_time_seconds
	}

func load_save_data(data: Dictionary) -> void:
	current_floor = data.get("current_floor", 1)
	visited_floors = data.get("visited_floors", [1])
	game_time_seconds = data.get("game_time_seconds", 0.0)
	game_phase = Phase.EXPLORING
