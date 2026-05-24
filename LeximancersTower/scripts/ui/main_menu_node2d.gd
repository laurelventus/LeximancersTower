## MainMenu2D — Node2D-based main menu with direct mouse handling.
extends Node2D

var _buttons: Array = []

func _ready() -> void:
	print("[MainMenu2D] Creating menu...")
	
	# Dark background
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.06, 0.12, 1.0)
	bg.size = Vector2(480, 270)
	bg.position = Vector2.ZERO
	add_child(bg)
	
	# Title
	_add_label("Leximancer's Tower", Vector2(240, 40), 20, true)
	
	# Buttons: rect, callback
	_add_button("New Game", Rect2(160, 85, 160, 30), "_on_new_game")
	_add_button("Continue", Rect2(160, 125, 160, 30), "_on_continue")
	_add_button("Settings", Rect2(160, 165, 160, 30), "_on_settings")
	_add_button("Quit", Rect2(160, 205, 160, 30), "_on_quit")
	
	# Camera
	var cam := Camera2D.new()
	cam.enabled = true
	cam.position = Vector2(240, 135)
	add_child(cam)
	cam.make_current()
	
	print("[MainMenu2D] Ready — %d buttons" % _buttons.size())

func _add_label(text: String, pos: Vector2, font_size: int, _bold: bool) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	var size := label.get_minimum_size()
	label.position = pos - size * 0.5
	add_child(label)

func _add_button(text: String, rect: Rect2, callback: String) -> void:
	# Background rect
	var btn_bg := ColorRect.new()
	btn_bg.color = Color(0.15, 0.12, 0.2, 1.0)
	btn_bg.size = rect.size
	btn_bg.position = rect.position
	add_child(btn_bg)
	
	# Label
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 14)
	label.size = rect.size
	label.position = rect.position
	add_child(label)
	
	# Store for click detection
	_buttons.append({"rect": rect, "callback": callback})

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos: Vector2 = event.position
		for btn in _buttons:
			var r: Rect2 = btn["rect"]
			if r.has_point(mouse_pos):
				print("[MainMenu2D] Clicked: " + btn["callback"])
				call(btn["callback"])
				return

func _on_new_game() -> void:
	print("[MainMenu2D] Starting new game...")
	var gm := get_node_or_null("/root/GameManager") as Node
	var sb := get_node_or_null("/root/SpellBook") as Node
	var inv := get_node_or_null("/root/Inventory") as Node
	var pm := get_node_or_null("/root/PuzzleManager") as Node
	if gm: gm.start_new_game()
	if sb: sb.reset()
	if inv: inv.reset()
	if pm: pm.reset()
	get_tree().change_scene_to_file("res://scenes/core/game.tscn")

func _on_continue() -> void:
	var save_mgr := get_node_or_null("/root/SaveManager") as Node
	if not save_mgr: return
	var data = save_mgr.load_game(1)
	if typeof(data) != TYPE_DICTIONARY or data.is_empty():
		data = save_mgr.load_game(0)
	if typeof(data) != TYPE_DICTIONARY or data.is_empty():
		return
	get_tree().change_scene_to_file("res://scenes/core/game.tscn")

func _on_settings() -> void:
	pass

func _on_quit() -> void:
	get_tree().quit()
