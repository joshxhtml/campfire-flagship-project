extends CanvasLayer

#onreadys
@onready var round_label := $Panel/Control/RoundReached
@onready var score_label := $Panel/Control/TotalScore
@onready var balls_label := $Panel/Control/BallsShot
@onready var powerups_label := $Panel/Control/PowerupsBought

#intialization
func _ready() -> void:
	AudioManager.play_music(AudioManager.Music.MAIN_MENUS)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show_stats()

#core funcs
func show_stats():
	round_label.text = "Round Reached: %d" % GameManager.roundnum
	score_label.text = "Total Score %d" % GameManager.total_score
	balls_label.text = "Balls Shot: %d" % GameManager.total_balls_shot
	powerups_label.text = "Powerups Owned: %d" % GameManager.get_total_powerups_owned()

#buttons
func _on_play_again_pressed() -> void:
	GameManager.restart_run()
	get_tree().change_scene_to_file("res://main.tscn")
func _on_quit_pressed() -> void:
	GameManager.restart_run()
	get_tree().change_scene_to_file("res://main_menu.tscn")
