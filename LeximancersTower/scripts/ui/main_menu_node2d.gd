## MainMenu2D — Node2D-based main menu using Area2D buttons.
## Avoids Control layout issues entirely.
extends Node2D

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
	
	# Buttons
	_add_button("New Game", Vector2(240, 100), "_on_new_game")
	_add_button("Continue", Vector2(240, 140), "_on_continue")
	_add_button("Settings", Vector2(240, 180), "_on_settings")
	_add_button("Quit", Vector2(240, 220), "_on_quit")
	
	# Camera
	var cam := Camera2D.new()
	cam.enabled = true
	cam.position = Vector2(240, 135)
	add_child(cam)
	cam.make_current()
	
	print("[MainMenu2D] Ready")

func _add_label(text: String, pos: Vector2, font_size: int, bold: bool) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	var size := label.get_minimum_size()
	label.position = pos - size * 0.5
	add_child(label)

func _add_button(text: String, pos: Vector2, callback: String) -> void:
	# Background rect
	var btn_bg := ColorRect.new()
	btn_bg.color = Color(0.15, 0.12, 0.2, 1.0)
	btn_bg.size = Vector2(160, 30)
	btn_bg.position = pos - Vector2(80, 15)
	add_child(btn_bg)
	
	# Label
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 14)
	label.size = Vector2(160, 30)
	label.position = pos - Vector2(80, 15)
	add_child(label)
	
	# Clickable area
	var area := Area2D.new()
	area.name = text.replace(" ", "") + "Area"
	var col := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(160, 30)
	col.shape = rect
	col.position = Vector2(80, 15)
	area.add_child(col)
	area.position = pos - Vector2(80, 15)
	area.input_pickable = true
	area.input_event.connect(_on_button_clicked.bind(callback))
	add_child(area)

func _on_button_clicked(_viewport: Node, event: InputEvent, _shape_idx: int, callback: String) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("[MainMenu2D] Clicked: " + callback)
		call(callback)

func _on_new_game() -> void:
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
