## Game — Root game scene: loads floor scenes and manages UI overlay.
extends Node2D

@onready var _floor_container: Node2D = $FloorContainer
@onready var _ui_layer: CanvasLayer = $UILayer

var _current_floor_scene: Node = null

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
	var gm := get_node("/root/GameManager") as Node
	gm.floor_changed.connect(_on_floor_changed)
	_load_floor(gm.current_floor)

func _load_floor(floor: int) -> void:
	if _current_floor_scene:
		_current_floor_scene.queue_free()
		_current_floor_scene = null
	
	if FLOOR_SCENES.has(floor):
		var path: String = FLOOR_SCENES[floor]
		if ResourceLoader.exists(path):
			var scene: PackedScene = load(path)
			if scene:
				_current_floor_scene = scene.instantiate()
				_floor_container.add_child(_current_floor_scene)

func _on_floor_changed(floor: int) -> void:
	_load_floor(floor)
