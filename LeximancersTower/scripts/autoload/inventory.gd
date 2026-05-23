## Inventory — Manages collected items and quantities.
## Autoload: items keyed by id with stackable counts.

extends Node

signal item_added(item_id: String)
signal item_removed(item_id: String)
signal inventory_changed

const MAX_SLOTS: int = 20

var _items: Dictionary = {}   # id -> { name_en, name_zh, icon_path, count, is_key_item }

func add_item(item_id: String, name_en: String = "", name_zh: String = "", is_key: bool = false) -> bool:
	if _items.has(item_id):
		_items[item_id].count += 1
	else:
		if _items.size() >= MAX_SLOTS:
			print("[Inventory] Full! Cannot add %s" % name_en)
			return false
		_items[item_id] = {
			"name_en": name_en,
			"name_zh": name_zh,
			"count": 1,
			"is_key_item": is_key
		}
	item_added.emit(item_id)
	inventory_changed.emit()
	print("[Inventory] + %s (x%d)" % [name_en, _items[item_id].count])
	return true

func remove_item(item_id: String, amount: int = 1) -> bool:
	if not _items.has(item_id):
		return false
	_items[item_id].count -= amount
	if _items[item_id].count <= 0:
		_items.erase(item_id)
	item_removed.emit(item_id)
	inventory_changed.emit()
	return true

func has_item(item_id: String, amount: int = 1) -> bool:
	return _items.has(item_id) and _items[item_id].count >= amount

func has_all(items: Array) -> bool:
	for entry in items:
		var item_id: String = entry[0] if entry is Array else entry
		var amt: int = entry[1] if entry is Array and entry.size() > 1 else 1
		if not has_item(item_id, amt):
			return false
	return true

func get_item_count(item_id: String) -> int:
	return _items.get(item_id, {}).get("count", 0)

func get_all_items() -> Array:
	var result: Array = []
	for id in _items:
		result.append({
			"id": id,
			"name_en": _items[id].name_en,
			"name_zh": _items[id].name_zh,
			"count": _items[id].count,
			"is_key_item": _items[id].is_key_item
		})
	return result

func reset() -> void:
	_items.clear()

func get_save_data() -> Dictionary:
	return {"items": _items.duplicate(true)}

func load_save_data(data: Dictionary) -> void:
	_items = data.get("items", {})
