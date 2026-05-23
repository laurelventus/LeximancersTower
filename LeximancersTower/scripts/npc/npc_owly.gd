## Owly NPC — Guide owl that speaks to the player.
extends Area2D

@export var npc_id: String = "owly"
@export var dialogue_key: String = "first_meeting"

signal dialogue_triggered

var _has_met_player: bool = false
var _hint_count: int = 0

func _ready() -> void:
	body_entered.connect(_on_player_near)

func _on_player_near(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	var dm := get_node("/root/DialogueManager") as Node
	if not dm:
		return
	
	if not _has_met_player:
		_has_met_player = true
		var gm := get_node("/root/GameManager") as Node
		if gm:
			gm.set_phase(1)  # DIALOGUE
		dm.start_dialogue(npc_id, dialogue_key)
		dialogue_triggered.emit()

func on_interact() -> void:
	var dm := get_node("/root/DialogueManager") as Node
	if not dm:
		return
	
	var gm := get_node("/root/GameManager") as Node
	var pm := get_node("/root/PuzzleManager") as Node
	var unsolved: Array = pm.get_unsolved_on_floor(1) if pm else []
	
	if unsolved.size() > 0 and _hint_count < 2:
		_hint_count += 1
		if gm:
			gm.set_phase(1)
		if "floor1_light_torch" in unsolved:
			dm.start_dialogue(npc_id, "hint_torch")
		else:
			dm.start_dialogue(npc_id, "hint_door")
	else:
		if gm:
			gm.set_phase(1)
		dm.start_dialogue(npc_id, "first_meeting")
