extends CanvasLayer
@onready var round_label := $Control/Panel/Control/RoundReached
@onready var score_label := $Control/Panel/Control/TotalScore
@onready var balls_label := $Control/Panel/Control/BallsShot
@onready var powerups_label := $Control/Panel/Control/PowerupsBought

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show_stats()

func show_stats():
	round_label.text = "Round: %d" % GameManager.roundnum
	score_label.text = "Score: %d" % GameManager.total_score
	balls_label.text = "Balls Shot: %d" % GameManager.total_balls_shot
	powerups_label.text = "Powerups Owned: %d" % GameManager.get_total_powerups_owned()
	
func _on_resume_pressed() -> void:
	print("[PASUE] Resume Pressed")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameManager.resume_game()

func _on_save_run_pressed() -> void:
	GameManager.save_run()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
