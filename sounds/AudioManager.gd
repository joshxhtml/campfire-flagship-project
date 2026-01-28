extends Node

enum Music {
	NONE,
	MAIN_MENUS,
	GAME
}

@onready var player := AudioStreamPlayer.new()

const TRACKS := {
	Music.MAIN_MENUS: preload("res://sounds/autismisland.ogg"),
	Music.GAME: preload("res://sounds/movingrightalong.ogg"),
}
var current_music := Music.NONE

func _ready():
	add_child(player)
	player.bus = "Music"

func play_music(music: Music):
	if current_music == music:
		return
	current_music = music
	player.stop()
	
	if music == Music.NONE:
		return
	
	player.stream = TRACKS[music]
	player.play()

func stop():
	current_music = Music.NONE
	player.stop()
