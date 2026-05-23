## Localization — Bilingual UI (Chinese / English) via CSV translation.
## Autoload: uses Godot's built-in TranslationServer.

extends Node

signal language_changed(lang: String)

enum Language { EN, ZH }

var current_lang: Language = Language.ZH

func _ready() -> void:
	pass

func set_language(lang: Language) -> void:
	current_lang = lang
	TranslationServer.set_locale("zh" if lang == Language.ZH else "en")
	language_changed.emit("zh" if lang == Language.ZH else "en")

func toggle() -> void:
	set_language(Language.EN if current_lang == Language.ZH else Language.ZH)

func get_text(key: String) -> String:
	# Wraps Godot's tr() for UI text
	return key  # Placeholder: CSV-based translation via Godot's tr()

func get_save_data() -> Dictionary:
	return {"current_lang": current_lang}

func load_save_data(data: Dictionary) -> void:
	set_language(data.get("current_lang", Language.ZH))
