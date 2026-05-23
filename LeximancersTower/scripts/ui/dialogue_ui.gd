## DialogueUI — Bottom-bar dialogue display with typewriter effect.
extends Control

signal dialogue_finished

@onready var _speaker_label: Label = $Panel/SpeakerLabel
@onready var _text_label: RichTextLabel = $Panel/TextLabel
@onready var _continue_hint: Label = $Panel/ContinueHint

var _is_active: bool = false
var _current_text: String = ""
var _char_index: int = 0
var _type_timer: float = 0.0
var _chars_per_second: float = 30.0

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if not _is_active:
		return
	
	if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("spell_book"):
		if _char_index < _current_text.length():
			# Skip to end
			_char_index = _current_text.length()
			_text_label.text = _current_text
		else:
			_advance_dialogue()
	
	# Typewriter effect
	if _char_index < _current_text.length():
		_type_timer += delta
		while _type_timer >= 1.0 / _chars_per_second and _char_index < _current_text.length():
			_char_index += 1
			_text_label.text = _current_text.substr(0, _char_index)
			_type_timer -= 1.0 / _chars_per_second

func show_dialogue(speaker: String, text: String) -> void:
	visible = true
	_is_active = true
	_speaker_label.text = speaker
	_current_text = text
	_char_index = 0
	_text_label.text = ""
	_type_timer = 0.0
	_continue_hint.visible = false

func _advance_dialogue() -> void:
	var dm := get_node("/root/DialogueManager") as Node
	if not dm:
		hide_dialogue()
		return
	
	if dm.is_finished():
		hide_dialogue()
		dialogue_finished.emit()
		return
	
	var next_line: Dictionary = dm.advance()
	if next_line.is_empty():
		hide_dialogue()
		dialogue_finished.emit()
	else:
		show_dialogue(next_line.get("speaker", ""), next_line.get("text", ""))

func hide_dialogue() -> void:
	visible = false
	_is_active = false
	var gm := get_node("/root/GameManager") as Node
	if gm:
		gm.set_phase(1)  # EXPLORING
