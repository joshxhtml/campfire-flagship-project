extends Node3D

#worlds bext script ever
func _ready():
	AudioManager.play_music(AudioManager.Music.GAME)
	GameManager.start_game()
