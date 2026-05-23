## SpellBook — Manages collected spell fragments and casting.
## Autoload: spells are stored as { id, word, category } dictionaries.

extends Node

signal spell_collected(spell_id: String)
signal spell_cast(spell_id: String, target_path: String)
signal spell_failed(spell_id: String)

enum Category { ACTION, ELEMENT, NATURE, OBJECT, DIRECTION, MAGIC }

var _spells: Dictionary = {}          # id -> { word, category, collected }
var _spell_order: Array[String] = []  # preserved collection order

func add_spell(spell_id: String, word: String, category: int = Category.ACTION) -> void:
	if _spells.has(spell_id):
		return
	_spells[spell_id] = {
		"word": word,
		"category": category,
		"collected": true
	}
	_spell_order.append(spell_id)
	spell_collected.emit(spell_id)
	print("[SpellBook] Collected: %s" % word)

func has_spell(spell_id: String) -> bool:
	return _spells.has(spell_id)

func cast_spell(spell_id: String, target_path: String = "") -> bool:
	if not has_spell(spell_id):
		spell_failed.emit(spell_id)
		return false
	var spell = _spells[spell_id]
	spell_cast.emit(spell_id, target_path)
	print("[SpellBook] Cast: %s → %s" % [spell.word, target_path if target_path else "self"])
	return true

func get_all_spells() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for id in _spell_order:
		if _spells.has(id):
			result.append({"id": id, "word": _spells[id].word, "category": _spells[id].category})
	return result

func get_spells_by_category(category: int) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for id in _spell_order:
		if _spells.has(id) and _spells[id].category == category:
			result.append({"id": id, "word": _spells[id].word, "category": _spells[id].category})
	return result

func get_spell_count() -> int:
	return _spells.size()

func reset() -> void:
	_spells.clear()
	_spell_order.clear()

func get_save_data() -> Dictionary:
	return {
		"spells": _spells.duplicate(true),
		"spell_order": _spell_order.duplicate()
	}

func load_save_data(data: Dictionary) -> void:
	_spells = data.get("spells", {})
	_spell_order = data.get("spell_order", [])
