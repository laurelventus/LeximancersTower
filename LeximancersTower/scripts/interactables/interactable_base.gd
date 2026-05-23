## InteractableBase — Base class for all interactive objects.
## NOTE: No class_name to avoid headless compilation issues.
extends Area2D

signal interacted
signal player_entered_range
signal player_exited_range

@export var interaction_label: String = ""
@export var interaction_label_en: String = ""
@export var is_one_shot: bool = false
@export var requires_spell: String = ""

var _used: bool = false

func _ready() -> void:
	if interaction_label_en.is_empty():
		interaction_label_en = interaction_label
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func on_interact() -> void:
	if is_one_shot and _used:
		return
	if not requires_spell.is_empty():
		var sb := get_node("/root/SpellBook") as Node
		if not sb or not sb.has_spell(requires_spell):
			print("[Interactable] Need spell: %s" % requires_spell)
			return
		sb.cast_spell(requires_spell, get_path())
	_used = true
	interacted.emit()
	_interact_effect()

func _interact_effect() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_entered_range.emit()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_exited_range.emit()
