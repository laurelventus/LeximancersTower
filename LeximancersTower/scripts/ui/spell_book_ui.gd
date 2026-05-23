## SpellBookUI — Overlay panel showing collected spells.
## Press Tab to toggle. Click a spell to cast it on the current target.
extends Control

signal spell_selected(spell_id: String)

@onready var _spell_list: VBoxContainer = $Panel/ScrollContainer/SpellList
@onready var _close_btn: Button = $Panel/CloseBtn

var _visible: bool = false
var _spell_buttons: Array = []
var _current_target_path: String = ""

func _ready() -> void:
	visible = false
	_close_btn.pressed.connect(_on_close)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spell_book"):
		toggle()

func toggle() -> void:
	_visible = not _visible
	visible = _visible
	if _visible:
		_refresh_list()
		var gm := get_node("/root/GameManager") as Node
		if gm:
			gm.set_phase(4)  # SPELL_BOOK
	else:
		var gm := get_node("/root/GameManager") as Node
		if gm:
			gm.set_phase(1)  # EXPLORING

func _refresh_list() -> void:
	# Clear old buttons
	for btn in _spell_buttons:
		btn.queue_free()
	_spell_buttons.clear()
	
	var sb := get_node("/root/SpellBook") as Node
	var spells: Array = sb.get_all_spells() if sb else []
	
	for entry in spells:
		var btn := Button.new()
		btn.text = entry["word"]
		btn.pressed.connect(_on_spell_clicked.bind(entry["id"]))
		_spell_list.add_child(btn)
		_spell_buttons.append(btn)

func _on_spell_clicked(spell_id: String) -> void:
	spell_selected.emit(spell_id)
	print("[SpellBookUI] Selected: %s" % spell_id)
	
	# Cast on current target (set by game scene)
	var sb := get_node("/root/SpellBook") as Node
	if sb:
		sb.cast_spell(spell_id, _current_target_path)
	
	# Auto-close after casting
	toggle()

func _on_close() -> void:
	toggle()

func set_target_path(path: String) -> void:
	_current_target_path = path
