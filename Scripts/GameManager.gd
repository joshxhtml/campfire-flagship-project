extends Node

var score := 0
var roundnum := 1
var balls_per_round := 3
var balls_left := 3

var round_score_goal := 10

signal round_started(round)
signal balls_changed(balls_left)
signal score_changed(score)
signal round_failed
signal round_completed

enum GameState {
	PLAYING,
	ROUND_TRANSITION,
	GAME_OVER
}

var game_state := GameState.PLAYING

func start_round():
	balls_left = balls_per_round
	round_score_goal = 10 * roundnum
	
	emit_signal("round_started", round)
	emit_signal("balls_changed", balls_left)
	emit_signal("score_changed", score)
	
func add_score(amount: int):
	score += amount
	emit_signal("score_changed", score)
	
	if score >= round_score_goal:
		emit_signal("round_completed")

func use_ball():
	balls_left -= 1
	emit_signal("balls_changed", balls_left)
	if balls_left <= 0 and score < round_score_goal:
		emit_signal("round_failed")

func next_round():
	roundnum += 1
	start_round()
