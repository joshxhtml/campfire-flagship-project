extends CanvasLayer

@onready var balls_countainer = $HUD/BallsCountainer

@onready var hud = $HUD
@onready var round_overlay = $RoundOverlay
@onready var round_image = $GameOverOverlay/TextureRect
@onready var game_over_overlay = $GameOverOverlay
@onready var final_score_label = $GameOverOverlay/TextureRect

@onready var greg := $HUD/Greg

func update_balls(count):
	for i in balls_countainer.get_child_count():
		balls_countainer.get_child(i).visible = i < count
		

func show_round_flash(roundnum):
	$HUD/RoundFlash.text = "ROUND %s" % str(roundnum)
	$HUD/RoundFlash.visible = true
	$HUD/RoundFlash.modulate.a = 1.0
	
	var tween = create_tween()
	tween.tween_property($HUD/RoundFlash, "modulate:a", 0.0, 1.2)
	
func _ready():
	
	GameManager.round_started.connect(on_round_started)
	GameManager.balls_changed.connect(update_balls)
	GameManager.round_score_changed.connect(update_round_score)
	GameManager.total_score_changed.connect(update_total_score)
	GameManager.round_completed.connect(on_round_completed)
	GameManager.round_failed.connect(on_round_failed)
	
	GameManager.start_round()

func on_round_started(_roundnum):
	greg.set_emotion(greg.Emotion.NUETRAL)
	hud.visible = false
	round_image.visible = true
	round_image.texture = preload("res://images/Round_Cleared.png")
	
	await get_tree().create_timer(1.5).timeout
	round_image.visible = false
	hud.visible = true
	GameManager.state = GameManager.GameState.PLAYING

func update_round_score(score):
	$HUD/RoundScoreLabel.text = "Round: %d / %d" % [score, GameManager.round_score_goal]
	
	if score >= GameManager.round_score_goal:
		greg.set_emotion(greg.Emotion.HAPPY)
	
func update_total_score(score):
	$HUD/TotalScoreLabel.text = "Total: %d" % score
	
func on_round_completed(_roundnum):
	hud.visible = false
	round_image.visible = true
	round_image.texture = preload("res://images/Round_Cleared.png")
	await get_tree().create_timer(2.0).timeout
	round_image.visible = false
	GameManager.start_round()


func on_round_failed(_roundnum):
	greg.set_emotion(greg.Emotion.DISAPPOINTED)
	hud.visible = false
	round_image.visible = true
	round_image.texture = preload("res://images/Round_Failed.png")
