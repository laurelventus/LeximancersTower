## MainMenu — Title screen with New Game / Continue / Settings.
extends Control

@onready var _new_game_btn: Button = $VBoxContainer/NewGameBtn
@onready var _continue_btn: Button = $VBoxContainer/ContinueBtn
@onready var _settings_btn: Button = $VBoxContainer/SettingsBtn
@onready var _quit_btn: Button = $VBoxContainer/QuitBtn
@onready var _title_label: Label = $TitleLabel


func _ready() -> void:
	_new_game_btn.pressed.connect(_on_new_game)
	_continue_btn.pressed.connect(_on_continue)
	_settings_btn.pressed.connect(_on_settings)
	_quit_btn.pressed.connect(_on_quit)
	
	var save_mgr := get_node("/root/SaveManager") if has_node("/root/SaveManager") else null
	if save_mgr:
		_continue_btn.disabled = not save_mgr.slot_exists(0) and not save_mgr.slot_exists(1)

func _on_new_game() -> void:
	var gm := get_node("/root/GameManager") as Node
	var sb := get_node("/root/SpellBook") as Node
	var inv := get_node("/root/Inventory") as Node
	var pm := get_node("/root/PuzzleManager") as Node
	
	gm.start_new_game()
	sb.reset()
	inv.reset()
	pm.reset()
	get_tree().change_scene_to_file("res://scenes/core/game.tscn")

func _on_continue() -> void:
	var save_mgr := get_node("/root/SaveManager") as Node
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
