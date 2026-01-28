extends Node

#shop const
const SHOP_SCENE := preload("res://ShopScenes/ShopScene.tscn")

# exports
@export var hole_lock_start_round := 5
@export var hole_lock_interval := 5 #maybe 10
@export var total_holes := 7

#onreadys
@onready var PAUSE_MENU := preload("res://UI/pause_menu.tscn")

#signals (for round status)
signal round_started(roundnum)
signal round_completed(roundnum)
signal round_failed(roundnum)
signal state_changed(state)

#signals for ball status
signal balls_changed(count)

#signals for score status
signal round_score_changed(score)
signal total_score_changed(score)

#signals for greg
signal greg_shot_made
signal greg_shot_missed
signal greg_hit_100
signal greg_random
signal greg_round_start()
signal greg_game_over

#enum
enum GameState {
	MENU,
	PLAYING,
	ROUND_TRANSITION,
	SHOP,
	GAME_OVER
}

#vars
var state = GameState.PLAYING
var game_started := false

#vars - round socring
var roundnum := 0
var round_score := 0
var total_score := 0
var round_score_goal := 0

#vars - ball managment
var active_balls := 0
var base_balls := 3
var extra_balls_per_round := 0
var extra_balls_remaining := 0
var balls_left := 0

#vars - shop management
var shop_interval := 1
var score_multiplier := 1.0
var owned_powerups:= {}
var shop_rerolled := false
var active_shop: CanvasLayer = null

#vars - powerups
var first_score_this_round := true
var last_hole_id := ""
var combo_count := 0
var total_balls_shot:= 0
var free_shots_remaining := 0
var used_second_chance := false
var miss_count := 0
#var golden_hole_id := ""
#var lock_jammer_hole_id := ""
var chaos_triggered := false

#vars - misc
var active_puase_menu: Node = null
var locked_holes: Array[String] = []
var tutorial := false


#starting logic
func start_game():
	if game_started:
		return
	game_started = true
	start_round()
func start_round():
	if not game_started:
		game_started = true
	roundnum += 1
	
	update_locked_holes()
	
	active_balls = 0
	balls_left = base_balls 
	extra_balls_remaining = extra_balls_per_round
	
	if owned_powerups.has("warm_up"):
		free_shots_remaining = 2
	
	first_score_this_round = true
	last_hole_id = ""
	combo_count = 0
	
	round_score = 0
	round_score_goal = 10 * roundnum
	state = GameState.ROUND_TRANSITION
	
	emit_signal("state_changed", state)
	emit_signal("round_score_changed", round_score)
	emit_signal("total_score_changed", total_score)
	emit_signal("balls_changed", balls_left)
	emit_signal("round_started", roundnum)
	emit_signal("greg_round_start")

#round logic
func round_ready():
	allow_play()
func allow_play():
	state = GameState.PLAYING
	emit_signal("state_changed", state)
func can_shoot() -> bool:
	
	return state == GameState.PLAYING and (balls_left > 0 or extra_balls_remaining > 0)
func check_round_end():
	if balls_left <= 0 and extra_balls_remaining <=0 and active_balls <= 0:
		evaluate_round()
func evaluate_round():
	state = GameState.ROUND_TRANSITION
	emit_signal("state_changed", state)
	
	if round_score >= round_score_goal:
		if should_open_shop():
			open_shop()
			
		else:
			emit_signal("round_completed", roundnum)
	else:
		state = GameState.GAME_OVER
		emit_signal("round_failed", roundnum)
		emit_signal("greg_game_over")

#pause logic
func open_pause_menu():
	if active_puase_menu:
		return
	if not can_pause():
		return
	
	get_tree().paused = true
	active_puase_menu = PAUSE_MENU.instantiate()
	get_tree().current_scene.add_child(active_puase_menu)
func resume_game():
	if active_puase_menu:
		active_puase_menu.queue_free()
		active_puase_menu = null
	
	get_tree().paused = false
func can_pause() -> bool:
	return state == GameState.PLAYING

#score logic
func add_score(points: int, hole_id: String, is_top_row: bool):
	var final_points = points
	var multiplier := score_multiplier
	
	#score surge powerup
	if owned_powerups.has("score_surge") and first_score_this_round:
		multiplier *= 2.0
		first_score_this_round = false
	
	# perfect aim powerup
	if  owned_powerups.has("perfect_aim") and hole_id == last_hole_id:
		multiplier *= 1.5
		
	#combo counter powerup
	if owned_powerups.has("combo_counter"):
		multiplier *= (1.0 +(.02 * combo_count))
		
	#high roller powerup
	if owned_powerups.has("high_roller") and is_top_row:
		final_points += 10
	
	#last ball bonus powerup
	if owned_powerups.has("last_ball_bonus") and is_last_ball():
		multiplier *= 2.0
	
	final_points = int(final_points * multiplier)
	
	if final_points >= 100:
		emit_signal("greg_hit_100")
	else:
		emit_signal("greg_shot_made")
	
	round_score += final_points
	total_score += final_points
	
	emit_signal("round_score_changed", round_score)
	emit_signal("total_score_changed", total_score)
	
	first_score_this_round = false
	last_hole_id = hole_id
	combo_count += 1
func register_miss():
	combo_count = 0
	last_hole_id = ""
	miss_count += 1
	emit_signal("greg_shot_missed")

func other_kind_of_miss():
	emit_signal("greg_shot_missed")
#ball logic
func use_ball():
	if state != GameState.PLAYING:
		return
	total_balls_shot += 1
	
	if free_shots_remaining > 0:
		free_shots_remaining -= 1
		active_balls += 1
		emit_signal("balls_changed", balls_left)
		return
	
	if extra_balls_remaining > 0:
		extra_balls_remaining -= 1
	else:
		balls_left -= 1
	active_balls += 1
	emit_signal("balls_changed", balls_left)
func ball_resolved():
	active_balls -= 1
	if randf() < .25:
		emit_signal("greg_random")
	check_round_end()
func is_last_ball() -> bool:
	return balls_left == 0 and extra_balls_remaining == 0

#shop logic
func should_open_shop() -> bool:
	return roundnum % shop_interval == 0
func open_shop():
	if active_shop != null:
		return
	
	state = GameState.SHOP
	shop_rerolled = false
	emit_signal("state_changed", state)
	
	active_shop = SHOP_SCENE.instantiate()
	get_tree().current_scene.add_child(active_shop)
func return_from_shop():
	if active_shop:
		active_shop.queue_free()
		active_shop = null
	
	state = GameState.ROUND_TRANSITION
	emit_signal("state_changed", state)
	start_round()
func spend_score(amount: int):
	if total_score < amount:
		return false
	
	total_score -= amount
	emit_signal("total_score_changed", total_score)
	return true
func can_afford(amount: int) -> bool:
	return total_score >= amount

#powerup logic
func apply_powerup(powerup: PowerUp):
	
	if not owned_powerups.has(powerup.id):
		owned_powerups[powerup.id] = 0
	
	owned_powerups[powerup.id] += 1
	
	match powerup.id:
		"score_multiplier":
			score_multiplier += .25
		"shop_frequency":
			shop_interval = 2
		"extra_ball":
			extra_balls_per_round += 1
		"score_surge":
			pass
		"perfect_aim":
			pass
		"high_roller":
			pass
		"combo_counter":
			pass
		"last_ball_bonus":
			pass
func get_total_powerups_owned():
	var count:= 0
	for k in owned_powerups.keys():
		count += owned_powerups[k]
	return count

#restating logic
func restart_run():
	
	# game states
	state = GameState.PLAYING
	game_started = false
	
	#progression
	roundnum = 0
	round_score = 0
	total_score = 0
	round_score_goal = 0
	
	# balls
	active_balls = 0
	balls_left = 0
	extra_balls_per_round = 0
	extra_balls_remaining = 0
	base_balls = 3
	total_balls_shot = 0
	
	# powerups
	owned_powerups.clear()
	score_multiplier = 1.0
	shop_interval = 5
	shop_rerolled = false
	
	# combo
	first_score_this_round = true
	last_hole_id = ""
	combo_count = 0
	
	# just in case stuff, idk how this would work but you enver knwo
	if active_shop:
		active_shop.queue_free()
		active_shop = null
	
	get_tree().paused = false

#hole locking logic
func update_locked_holes():
	var scoring_holes := get_tree().get_nodes_in_group("scoring_hole")
	var all_ids: Array[String] = []
	
	for hole in scoring_holes:
		all_ids.append(hole.hole_id)
	
	if roundnum < hole_lock_start_round:
		locked_holes.clear()
		for hole in scoring_holes:
			hole.set_locked(false)
		update_map()
		return
	
	var max_locks := all_ids.size() - 1
	
	
	@warning_ignore("integer_division")
	var locks_should_have := int(floor((roundnum - hole_lock_start_round) / hole_lock_interval) + 1)
	locks_should_have = min(locks_should_have, max_locks)
	
	locked_holes.clear()
	var shuffle_ids := all_ids.duplicate()
	shuffle_ids.shuffle()
	
	for i in range(locks_should_have):
		locked_holes.append(shuffle_ids[i])
	
	
	for hole in get_tree().get_nodes_in_group("scoring_hole"):
		hole.set_locked(locked_holes.has(hole.hole_id))
	
	update_map()
func is_hole_locked(hole_id: String) -> bool:
	return locked_holes.has(hole_id)
func update_map():
	var indicators := get_tree().get_nodes_in_group("map")
	
	for indicator in indicators:
		indicator.visible = locked_holes.has(indicator.hole_id)
