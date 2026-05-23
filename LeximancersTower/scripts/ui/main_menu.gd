## MainMenu — Title screen with New Game / Continue / Settings.
extends Control

func _ready() -> void:
	# Force full-screen anchors
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 0.0
	anchor_bottom = 1.0
	offset_left = 0
	offset_right = 0
	offset_top = 0
	offset_bottom = 0
	
	# Add dark background so it's never black
	var bg := ColorRect.new()
	bg.name = "MenuBG"
	bg.color = Color(0.08, 0.06, 0.12, 1.0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	bg.move_to_front()
	
	print("[MainMenu] Ready — connecting buttons")
	
	var new_btn := get_node_or_null("VBoxContainer/NewGameBtn") as Button
	var cont_btn := get_node_or_null("VBoxContainer/ContinueBtn") as Button
	var sett_btn := get_node_or_null("VBoxContainer/SettingsBtn") as Button
	var quit_btn := get_node_or_null("VBoxContainer/QuitBtn") as Button
	
	if new_btn:
		new_btn.pressed.connect(_on_new_game)
		print("[MainMenu] NewGameBtn connected")
	else:
		push_error("[MainMenu] NewGameBtn not found!")
	
	if cont_btn:
		cont_btn.pressed.connect(_on_continue)
		var save_mgr := get_node_or_null("/root/SaveManager") as Node
		if save_mgr:
			cont_btn.disabled = not save_mgr.slot_exists(0) and not save_mgr.slot_exists(1)
	else:
		push_error("[MainMenu] ContinueBtn not found!")
	
	if sett_btn:
		sett_btn.pressed.connect(_on_settings)
	
	if quit_btn:
		quit_btn.pressed.connect(_on_quit)

func _on_new_game() -> void:
	print("[MainMenu] New Game clicked")
	var gm := get_node_or_null("/root/GameManager") as Node
	var sb := get_node_or_null("/root/SpellBook") as Node
	var inv := get_node_or_null("/root/Inventory") as Node
	var pm := get_node_or_null("/root/PuzzleManager") as Node
	
	if not gm:
		push_error("[MainMenu] GameManager autoload not found!")
		return
	
	gm.start_new_game()
	if sb: sb.reset()
	if inv: inv.reset()
	if pm: pm.reset()
	
	print("[MainMenu] Changing to game scene...")
	var err := get_tree().change_scene_to_file("res://scenes/core/game.tscn")
	if err != OK:
		push_error("[MainMenu] Failed to change scene: %d" % err)

func _on_continue() -> void:
	print("[MainMenu] Continue clicked")
	var save_mgr := get_node_or_null("/root/SaveManager") as Node
	if not save_mgr:
		return
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
