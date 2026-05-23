## AudioManager — Manages SFX and BGM playback.
## Autoload: simple wrapper over AudioStreamPlayer nodes.

extends Node

var _sfx_players: Array[AudioStreamPlayer] = []
var _bgm_player: AudioStreamPlayer
var _sfx_volume_db: float = 0.0
var _bgm_volume_db: float = -6.0

func _ready() -> void:
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "Music"
	add_child(_bgm_player)
	# Pool of SFX players for overlapping sounds
	for i in range(8):
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_sfx_players.append(p)

func play_sfx(stream: AudioStream) -> void:
	for p in _sfx_players:
		if not p.playing:
			p.stream = stream
			p.play()
			return
	# All busy — steal the oldest
	_sfx_players[0].stream = stream
	_sfx_players[0].play()

func play_bgm(stream: AudioStream) -> void:
	if _bgm_player.stream == stream and _bgm_player.playing:
		return
	_bgm_player.stream = stream
	_bgm_player.play()

func stop_bgm() -> void:
	_bgm_player.stop()

func set_sfx_volume_db(db: float) -> void:
	_sfx_volume_db = db
	for p in _sfx_players:
		p.volume_db = db

func set_bgm_volume_db(db: float) -> void:
	_bgm_volume_db = db
	_bgm_player.volume_db = db
