extends Node

#round statuses
signal round_started(roundnum)
signal round_completed(roundnum)
signal round_failed(roundnum)
signal state_changed(state)

enum GameState {
	PLAYING,
	ROUND_TRANSITION,
	SHOP,
	GAME_OVER
}

#ball stauts
signal balls_changed(count)
#scores, new rule for easy managment on my part -> GameManager is the oinly script allowed to change the score
signal round_score_changed(score)
signal total_score_changed(score)


var state = GameState.PLAYING
#round socring
var roundnum := 0
var round_score := 0
var total_score := 0
var round_score_goal := 0
#ball managment
var active_balls := 0
var base_balls := 3
var extra_balls_per_round := 0
var extra_balls_remaining := 0
var balls_left 
#shop varibles
var shop_interval := 1
var score_multiplier := 1.0
var owned_powerups:= {}
var shop_rerolled := false
#new powerup varaibles
var first_score_this_round := true
var last_hole_id := ""
var combo_count := 0

# Break to how the rounds flow

func start_round():
	roundnum += 1
	active_balls = 0
	balls_left = base_balls 
	extra_balls_remaining = extra_balls_per_round
	
	first_score_this_round = true
	last_hole_id = ""
	combo_count = 0
	
	round_score = 0
	round_score_goal = 10 * roundnum
	print("[BALLS] Round start: ", "Base: ", balls_left, ", Extra this round: ", extra_balls_remaining, " (Permanent bonus: ", extra_balls_per_round, ")")
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
	return state == GameState.PLAYING and (balls_left > 0 or extra_balls_remaining > 0)


# Break for scoring stuff
func add_score(points: int, hole_id: String, is_top_row: bool):
	var final_points = points
	var multiplier := score_multiplier
	
	#score surge powerup
	if owned_powerups.has("score_surge") and first_score_this_round:
		multiplier *= 2.0
		first_score_this_round = false
		print("[POWERUP] Score Surge activated")
	
	# perfect aim powerup
	if  owned_powerups.has("perfect_aim") and hole_id == last_hole_id:
		multiplier *= 1.5
		print("[POWERUP] Perfect Aim activated")
		
	#combo counter powerup
	if owned_powerups.has("combo_counter"):
		multiplier *= (1.0 +(.02 * combo_count))
		print("[POWERUP] Combo x", combo_count)
		
	#high roller powerup
	if owned_powerups.has("high_roller") and is_top_row:
		final_points += 10
		print("[POWERUP] High Roller Bonus activated")
	
	#last ball bonus powerup
	if owned_powerups.has("last_ball_bonus") and is_last_ball():
		multiplier *= 2.0
		print("[POWERUP] Last Ball Bonus")
	
	final_points = int(final_points * multiplier)
	round_score += final_points
	total_score += final_points
	
	emit_signal("round_score_changed", round_score)
	emit_signal("total_score_changed", total_score)
	
	first_score_this_round = false
	last_hole_id = hole_id
	combo_count += 1
	
#new ball logic for combo coutning
func register_miss():
	combo_count = 0
	last_hole_id = ""
	print("[COMBO] Combo Reset due to miss")
#Break for balls
func use_ball():
	if state != GameState.PLAYING:
		return
		
	if extra_balls_remaining > 0:
		extra_balls_remaining -= 1
		print("[BALL] Used EXTRA ball. Remaining extra:", extra_balls_remaining)
	else:
		balls_left -= 1
		print("[BALL] Used NORMAL ball. Balls left:", balls_left)
	active_balls += 1
	emit_signal("balls_changed", balls_left)

func ball_resolved():
	active_balls -= 1
	check_round_end()

func check_round_end():
	if balls_left <= 0 and extra_balls_remaining <=0 and active_balls <= 0:
		evaluate_round()

#break for ending of round
func evaluate_round():
	state = GameState.ROUND_TRANSITION
	emit_signal("state_changed", state)
	
	if round_score >= round_score_goal:
		if should_open_shop():
			state = GameState.SHOP
			shop_rerolled = false
			emit_signal("state_changed", state)
			get_tree().call_deferred("change_scene_to_file", "res://ShopScenes/ShopScene.tscn")
		else:
			emit_signal("round_completed", roundnum)
	else:
		state = GameState.GAME_OVER
		emit_signal("round_failed", roundnum)

#shop Stuff
func should_open_shop() -> bool:
	return roundnum % shop_interval == 0

func open_shop():
	state = GameState.SHOP
	shop_rerolled = false
	emit_signal("state_changed", state)
	get_tree().call_deferred("change_scene_to_file", "res://ShopScenes/ShopScene.tscn")

func return_from_shop():
	state = GameState.ROUND_TRANSITION
	emit_signal("state_changed", state)
	start_round()

func is_last_ball() -> bool:
	return balls_left == 0 and extra_balls_remaining == 0

# powerups
func apply_powerup(powerup: PowerUp):
	
	if not owned_powerups.has(powerup.id):
		owned_powerups[powerup.id] = 0
	
	owned_powerups[powerup.id] += 1
	
	match powerup.id:
		"score_multiplier":
			score_multiplier += .25
			print("[POWERUP] Activated:", powerup.id)
		"shop_frequency":
			shop_interval = 5
			print("[POWERUP] Activated:", powerup.id)
		"extra_ball":
			extra_balls_per_round += 1
			print("[POWERUP] Activated:", powerup.id)
			print("[POWERUP] Extra ball gained. Total extra: ", extra_balls_per_round)
		"score_surge":
			print("[POWERUP] Activated:", powerup.id)
		"perfect_aim":
			print("[POWERUP] Activated:", powerup.id)
		"high_roller":
			print("[POWERUP] Activated:", powerup.id)
		"combo_counter":
			print("[POWERUP] Activated:", powerup.id)
		"last_ball_bonus":
			print("[POWERUP] Activated:", powerup.id)
	
		
func spend_score(amount: int):
	if total_score < amount:
		return false
	
	total_score -= amount
	emit_signal("total_score_changed", total_score)
	return true

func can_afford(amount: int) -> bool:
	return total_score >= amount
