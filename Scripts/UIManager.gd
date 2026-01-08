extends CanvasLayer

@onready var balls_countainer = $HUD/BallsCountainer
@onready var extra_balls_label := $HUD/ExtraBallsLabel

@onready var hud = $HUD
@onready var round_image = $RoundStatusOverlay/RoundStatusTexture
@onready var game_over_overlay = $RoundStatusOverlay
@onready var greg := $HUD/Greg

func update_balls(count):
	for i in balls_countainer.get_child_count():
		balls_countainer.get_child(i).visible = i < count
		
	print("[UI] Balls: ", count, ", Extra: ", GameManager.extra_balls_remaining)
	if GameManager.extra_balls_remaining > 0:
		extra_balls_label.visible = true
		extra_balls_label.text = "+%d" % GameManager.extra_balls_remaining
	else:
		extra_balls_label.visible = false

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
	

func on_round_started(roundnum):
	greg.set_emotion(greg.Emotion.NUETRAL)
	
	var bg := $HUD/RoundFlashBG
	var label := $HUD/RoundFlash
	label.text = "Round %d" % roundnum
	
	bg.visible = true
	label.visible = true
	bg.modulate.a = 1.0
	label.modulate.a = 1.0
	
	var tween3 = create_tween()
	tween3.tween_property(bg, "modulate:a", 0.0, 1.2)
	tween3.parallel().tween_property(label, "modulate:a", 0.0, 1.2)
	await tween3.finished
	
	bg.visible = false
	label.visible = false
	
	GameManager.allow_play()

func update_round_score(score):
	$HUD/RoundScoreLabel.text = "Round: %d / %d" % [score, GameManager.round_score_goal]
	
	if score >= GameManager.round_score_goal:
		greg.set_emotion(greg.Emotion.HAPPY)
	
func update_total_score(score):
	$HUD/TotalScoreLabel.text = "Total: %d" % score
	
func on_round_completed(_roundnum):
	hud.visible = false
	round_image.visible = true
	round_image.texture = preload("res://images/roundclear.png")
	
	await get_tree().create_timer(2.0).timeout
	
	round_image.visible = false
	hud.visible = true
	
	GameManager.start_round()


func on_round_failed(_roundnum):
	greg.set_emotion(greg.Emotion.DISAPPOINTED)
	hud.visible = false
	round_image.visible = true
	round_image.texture = preload("res://images/roundfail.png")
	
	GameManager.state = GameManager.GameState.GAME_OVER
