extends CanvasLayer

@onready var round_label := $Panel/Control/RoundReached
@onready var score_label := $Panel/Control/TotalScore
@onready var balls_label := $Panel/Control/BallsShot
@onready var powerups_label := $Panel/Control/PowerupsBought

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show_stats()
	
func show_stats():
	round_label.text = "Round Reached: %d" % GameManager.roundnum
	score_label.text = "Total Score %d" % GameManager.total_score
	balls_label.text = "Balls Shot: %d" % GameManager.total_balls_shot
	powerups_label.text = "Powerups Owned: %d" % GameManager.get_total_powerups_owned()
	
	

func _on_play_again_pressed() -> void:
	queue_free()
	
	GameManager.restart_run()
	get_tree().change_scene_to_file("res://main.tscn")
	



func _on_quit_pressed() -> void:
	queue_free()
	
	GameManager.restart_run()
	get_tree().change_scene_to_file("res://main_menu.tscn")
