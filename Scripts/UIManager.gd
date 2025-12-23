extends CanvasLayer

@onready var balls_countainer = $BallsCountainer

func update_balls(count):
	for i in balls_countainer.get_child_count():
		balls_countainer.get_child(i).visible = i < count
		

func show_round_flash(roundnum):
	$RoundFlash.text = "ROUND %s" % str(roundnum)
	$RoundFlash.visible = true
	$RoundFlash.modulate.a = 1.0
	
	var tween = create_tween()
	tween.tween_property($RoundFlash, "modulate:a", 0.0, 1.2)
	
func _ready():
	GameManager.round_started.connect(on_round_started)
	GameManager.balls_changed.connect(update_balls)
	GameManager.score_changed.connect(update_score)
	GameManager.round_completed.connect(on_round_completed)
	GameManager.round_failed.connect(on_round_failed)
	
	GameManager.start_round()

func on_round_started(roundnum):
	show_round_flash(roundnum)
	$GoalLabel.text = "Goal: %d" % GameManager.round_score_goal

func update_score(score):
	$ScoreLabel.text = "Score: %d" % score

func on_round_completed():
	$RoundFlash.text = "ROUND CLEARED!"
	show_round_flash(GameManager.roundnum)
	await get_tree().create_timer(1.5).timeout
	GameManager.next_round()

func on_round_failed():
	$RoundFlash.text = "TRY AGAIN"
	show_round_flash(GameManager.roundnum)
