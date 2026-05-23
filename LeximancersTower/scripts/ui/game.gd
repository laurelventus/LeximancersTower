## Game — Root game scene: loads floor scenes and manages UI overlay.
extends Node2D

@onready var _floor_container: Node2D = $FloorContainer
@onready var _ui_layer: CanvasLayer = $UILayer

var _current_floor_scene: Node = null
var _spell_book_ui: Control = null
var _dialogue_ui: Control = null

const FLOOR_SCENES := {
	1: "res://scenes/levels/floor1_entrance.tscn",
	2: "res://scenes/levels/floor2_kitchen.tscn",
	3: "res://scenes/levels/floor3_greenhouse.tscn",
	4: "res://scenes/levels/floor4_library.tscn",
	5: "res://scenes/levels/floor5_workshop.tscn",
	6: "res://scenes/levels/floor6_observatory.tscn",
	7: "res://scenes/levels/floor7_chamber.tscn",
}

func _ready() -> void:
	_setup_ui()
	var gm := get_node("/root/GameManager") as Node
	gm.floor_changed.connect(_on_floor_changed)
	_load_floor(gm.current_floor)

func _setup_ui() -> void:
	var spell_book_scene := load("res://scenes/core/spell_book_ui.tscn") as PackedScene
	if spell_book_scene:
		_spell_book_ui = spell_book_scene.instantiate()
		_ui_layer.add_child(_spell_book_ui)
	
	var dialogue_scene := load("res://scenes/core/dialogue_ui.tscn") as PackedScene
	if dialogue_scene:
		_dialogue_ui = dialogue_scene.instantiate()
		_ui_layer.add_child(_dialogue_ui)
	
	var dm := get_node("/root/DialogueManager") as Node
	if dm and _dialogue_ui:
		if dm.has_signal("dialogue_advanced"):
			dm.dialogue_advanced.connect(_on_dialogue_line)
		if dm.has_signal("dialogue_ended"):
			dm.dialogue_ended.connect(_on_dialogue_end)
		if dm.has_signal("dialogue_started"):
			dm.dialogue_started.connect(_on_dialogue_start)

func _load_floor(level: int) -> void:
	if _current_floor_scene:
		_current_floor_scene.queue_free()
		_current_floor_scene = null
	
	if FLOOR_SCENES.has(level):
		var path: String = FLOOR_SCENES[level]
		if ResourceLoader.exists(path):
			var scene: PackedScene = load(path)
			if scene:
				_current_floor_scene = scene.instantiate()
				_floor_container.add_child(_current_floor_scene)

func _on_floor_changed(level: int) -> void:
	_load_floor(level)

func _on_dialogue_start(_npc_id: String) -> void:
	if _dialogue_ui:
		_dialogue_ui.show()

func _on_dialogue_line(line: Dictionary) -> void:
	if _dialogue_ui and _dialogue_ui.has_method("show_dialogue"):
		_dialogue_ui.show_dialogue(
			line.get("speaker", ""),
			line.get("text", "")
		)

func _on_dialogue_end(_npc_id: String) -> void:
	if _dialogue_ui and _dialogue_ui.has_method("hide_dialogue"):
		_dialogue_ui.hide_dialogue()
