## SaveManager — Save/Load game state to 3 slots + 1 auto-save.
## Autoload: persists all autoload states as JSON.

extends Node

signal save_completed(slot: int)
signal load_completed(slot: int)

const SAVE_DIR := "user://saves/"
const AUTO_SLOT := 0
const MANUAL_SLOTS := 3

var _auto_save_timer: float = 0.0
var _last_auto_save_floor: int = 0

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR.trim_suffix("/"))

func _process(delta: float) -> void:
	var gm := get_node("/root/GameManager") if has_node("/root/GameManager") else null
	if not gm:
		return
	if gm.game_phase == 1:  # EXPLORING
		_auto_save_timer += delta
		if _auto_save_timer > 120.0 or gm.current_floor != _last_auto_save_floor:
			_auto_save_timer = 0.0
			_last_auto_save_floor = gm.current_floor
			save_game(AUTO_SLOT)

func save_game(slot: int) -> bool:
	var gm := get_node("/root/GameManager") as Node
	var sb := get_node("/root/SpellBook") as Node
	var inv := get_node("/root/Inventory") as Node
	var pm := get_node("/root/PuzzleManager") as Node
	
	var data := {
		"version": 1,
		"timestamp": Time.get_datetime_string_from_system(),
		"game": gm.get_save_data(),
		"spells": sb.get_save_data(),
		"inventory": inv.get_save_data(),
		"puzzles": pm.get_save_data()
	}
	var path := _slot_path(slot)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_error("[SaveManager] Cannot write to slot %d" % slot)
		return false
	file.store_string(JSON.stringify(data, "  "))
	file.close()
	save_completed.emit(slot)
	print("[SaveManager] Saved to slot %d" % slot)
	return true

func load_game(slot: int) -> Dictionary:
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}
	var content := file.get_as_text()
	file.close()
	var data = JSON.parse_string(content)
	if not data or data.get("version", 0) < 1:
		push_warning("[SaveManager] Slot %d is corrupted or old version" % slot)
		return {}
	
	var gm := get_node("/root/GameManager") as Node
	var sb := get_node("/root/SpellBook") as Node
	var inv := get_node("/root/Inventory") as Node
	var pm := get_node("/root/PuzzleManager") as Node
	
	gm.load_save_data(data.get("game", {}))
	sb.load_save_data(data.get("spells", {}))
	inv.load_save_data(data.get("inventory", {}))
	pm.load_save_data(data.get("puzzles", {}))
	load_completed.emit(slot)
	return data

func slot_exists(slot: int) -> bool:
	return FileAccess.file_exists(_slot_path(slot))

func delete_save(slot: int) -> bool:
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		return false
	DirAccess.remove_absolute(path)
	return true

func _slot_path(slot: int) -> String:
	if slot == AUTO_SLOT:
		return SAVE_DIR + "auto_save.json"
	return SAVE_DIR + "slot_%d.json" % slot
