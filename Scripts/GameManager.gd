extends Node

signal round_started(roundnum)
signal round_completed(roundnum)
signal round_failed(roundnum)
signal balls_changed(count)
signal round_score_changed(score)
signal total_score_changed(score)
signal state_changed(state)
signal total_score_change(score)

enum GameState {
	PLAYING,
	ROUND_TRANSITION,
	SHOP,
	GAME_OVER
}

var state = GameState.PLAYING

var roundnum := 0
var balls_left := 3

var round_score := 0
var total_score := 0
var round_score_goal := 0

var active_balls := 0

var score_multiplier := 1.0
var owned_powerups:= {}

# Break to how the rounds flow

func start_round():
	roundnum += 1
	balls_left = 3
	round_score = 0
	round_score_goal = 10 * roundnum
	
	state = GameState.ROUND_TRANSITION
	emit_signal("state_changed", state)
	
	
	emit_signal("round_score_changed", round_score)
	emit_signal("total_score_changed", total_score)
	emit_signal("balls_changed", balls_left)
	emit_signal("round_started", roundnum)

func allow_play():
	state = GameState.PLAYING
	emit_signal("state_changed", state)

func can_shoot() -> bool:
	return state == GameState.PLAYING and balls_left > 0
# Break for scoring stuff
func add_score(points: int):
	
	var final_points = int(points * score_multiplier)
	
	round_score += final_points
	total_score += final_points
	
	emit_signal("round_score_changed", round_score)
	emit_signal("total_score_changed", total_score)
#Break for balls
func use_ball():
	if state != GameState.PLAYING:
		return
		
	balls_left -= 1
	active_balls += 1
	
	emit_signal("balls_changed", balls_left)
func ball_resolved():
	active_balls -= 1
	check_round_end()
func check_round_end():
	if balls_left <= 0 and active_balls <= 0:
		evaluate_round()
#break for ending of round
func evaluate_round():
	state = GameState.ROUND_TRANSITION
	emit_signal("state_changed", state)
	
	if round_score >= round_score_goal:
		if should_open_shop():
			state = GameState.SHOP
			emit_signal("state_changed", state)
			get_tree().call_deferred("change_scene_to_file", "res://ShopScene.tscn")
		else:
			emit_signal("round_completed", roundnum)
	else:
		state = GameState.GAME_OVER
		emit_signal("round_failed", roundnum)

#shop Stuff

func should_open_shop() -> bool:
	return roundnum % 1 == 0

func open_shop():
	state = GameState.SHOP
	emit_signal("state_changed", state)
	get_tree().call_deferred("change_scene_to_file", "res://ShopScene.tscn")

func return_from_shop():
	state = GameState.ROUND_TRANSITION
	emit_signal("state_changed", state)
	start_round()

# powerups

func apply_powerup(powerup: PowerUp):
	
	if not owned_powerups.has(powerup.id):
		owned_powerups[powerup.id] = 0
	
	owned_powerups[powerup.id] += 1
	
	if powerup.id == "score_multiplier":
		score_multiplier += .25
	
		
func spend_score(amount: int):
	total_score -= amount
	emit_signal("total_score_change", total_score)
