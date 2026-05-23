## DialogueManager — NPC dialogue display and history.
## Autoload: loads dialogue from JSON, manages display queue.

extends Node

signal dialogue_started(npc_id: String)
signal dialogue_advanced(line: Dictionary)
signal dialogue_ended(npc_id: String)

var _active: bool = false
var _lines: Array = []
var _line_index: int = 0
var _history: Array = []

func start_dialogue(npc_id: String, dialogue_key: String) -> Array:
	var data = _load_dialogue(npc_id, dialogue_key)
	if data.is_empty():
		push_warning("[Dialogue] Not found: %s/%s" % [npc_id, dialogue_key])
		return []
	_lines = data
	_line_index = 0
	_history.clear()
	_active = true
	dialogue_started.emit(npc_id)
	return _lines

func _load_dialogue(npc_id: String, dialogue_key: String) -> Array:
	var path = "res://assets/data/dialogue/%s.json" % npc_id
	if not FileAccess.file_exists(path):
		return []
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return []
	var content = file.get_as_text()
	file.close()
	var json = JSON.parse_string(content)
	if not json or not json.has(dialogue_key):
		return []
	return json[dialogue_key]  # Array of { text, highlight_words, speaker }

func advance() -> Dictionary:
	if not _active or _line_index >= _lines.size():
		_active = false
		dialogue_ended.emit("")
		return {}
	var line = _lines[_line_index]
	_history.append(line)
	_line_index += 1
	dialogue_advanced.emit(line)
	if _line_index >= _lines.size():
		_active = false
		await get_tree().create_timer(0.3).timeout
		dialogue_ended.emit("")
	return line

func get_current_line() -> Dictionary:
	if _active and _line_index < _lines.size():
		return _lines[_line_index]
	return {}

func is_active() -> bool:
	return _active

func is_finished() -> bool:
	return (not _active) or _line_index >= _lines.size()

func get_history() -> Array:
	return _history.duplicate()

func interrupt() -> void:
	_lines.clear()
	_line_index = 0
	_active = false
	dialogue_ended.emit("")
