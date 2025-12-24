extends Node

signal round_started(roundnum)
signal round_completed(roundnum)
signal round_failed(roundnum)
signal balls_changed(count)
signal score_changed(score)
signal state_changed(state)

enum GameState {
	PLAYING,
	ROUND_TRANSITION,
	GAME_OVER
}

var state = GameState.PLAYING

var roundnum := 0
var balls_left := 3
var score := 0
var round_score_goal := 0

var active_balls := 0

func start_round():
	roundnum += 1
	balls_left = 3
	score = 0
	round_score_goal = 10 * roundnum
	
	state = GameState.ROUND_TRANSITION
	emit_signal("state_changed", state)
	emit_signal("round_started", roundnum)

func can_shoot() -> bool:
	return state == GameState.PLAYING and balls_left > 0


func allow_play():
	state = GameState.PLAYING

func add_score(points):
	score += points
	emit_signal("score_changed", score)

func use_ball():
	if state != GameState.PLAYING:
		return
		
	balls_left -= 1
	active_balls += 1
	emit_signal("balls_changed", balls_left)
	
	check_round_end()


func evaluate_round():
	state = GameState.ROUND_TRANSITION
	
	if score >= round_score_goal:
		emit_signal("round_completed", roundnum)
	else:
		state = GameState.GAME_OVER
		emit_signal("round_failed", roundnum)

func ball_resolved():
	active_balls -= 1
	check_round_end()

func check_round_end():
	if balls_left <= 0 and active_balls <= 0:
		evaluate_round()
