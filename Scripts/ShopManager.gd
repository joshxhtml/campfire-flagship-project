extends Control

#building a debuging system, a) im bord and dont want to move onto content, and b) i need it cause this code is so ass 😭😭
const DEBUG_SHOP := true
#exports
@export var powerup_pool: Array[PowerUp]
@export var reroll_cost := 50
@export var card_scene: PackedScene

#my collection of onreadys
@onready var score_label := $Balance/TotalScoreLabel
@onready var cant_afford_popup := $Balance/CantAfford
@onready var reroll_button: Button = $RerollButton
@onready var exit_button: Button = $ExitButton
@onready var card_slots := [
	$Item1,
	$Item2,
	$Item3
]

var current_items: Array[PowerUp] = []


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cant_afford_popup.visible = false
	
	GameManager.total_score_changed.connect(update_total_score)
	update_total_score(GameManager.total_score)
	
	reroll_button.pressed.connect(_on_Reroll_pressed)
	exit_button.pressed.connect(_on_Exit_pressed)
	
	generate_items()

func generate_items():
	for slot in card_slots:
		for child in slot.get_children():
			child.queue_free()
	
	current_items.clear()
	reroll_button.disabled = GameManager.shop_rerolled
	
	for i in range(card_slots.size()):
		#hey josh dont forget you changed the var powerup to just p for simplicty dont like reference drong later
		var p = weighted_random(powerup_pool)
		current_items.append(p)
		
		var card = card_scene.instantiate()
		card.setup(p)
		card.purchased.connect(on_item_purchased)
		card_slots[i].add_child(card)

func on_item_purchased(powerup: PowerUp):
	#making a debug function for me
	
	if not GameManager.can_afford(powerup.cost):
		debug( 
			"PURCHASE " + powerup.id,
			false,
			{
				"cost": powerup.cost,
				"balance": GameManager.total_score,
				"reason": "insufficient balance"
			}
		)
		show_cant_afford()
		return
	
	GameManager.spend_score(powerup.cost)
	GameManager.apply_powerup(powerup)
	debug(
		"PURCHASE " + powerup.id,
		true,
		{
			"cost": powerup.cost,
			"remianing_balance": GameManager.total_score
		})
	exit_shop()

#did i see this in a video then completely steal the idea, yes, yes i did
func debug(action: String, success: bool, info := {}):
	if not DEBUG_SHOP:
		return
	
	var status := "SUCCESS" if success else "FAIL"
	print("")
	print("[SHOP] ", action, " -> ", status)
	
	for k in info.keys():
		print("  -", k, ": ", info[k])

func _on_Reroll_pressed():
	
	if GameManager.shop_rerolled:
		debug(
			"REROLL",
			false,
			{
				"reason": "already rerolled this shop session"
			}
		)
		return
	if GameManager.total_score < reroll_cost:
		debug(
			"REROLL",
			false,
			{
				"cost": reroll_cost,
				"balance": GameManager.total_score,
				"reason": "insufficient balance"
			})
		show_cant_afford()
		return

	GameManager.spend_score(reroll_cost)
	GameManager.shop_rerolled = true
	generate_items()
	debug(
		"REROLL",
		true,
		{
			"cost": reroll_cost,
			"remaining_balance": GameManager.total_score
		})

func _on_Exit_pressed():
	exit_shop()

func exit_shop():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.allow_play()
	GameManager.start_round()
	get_tree().change_scene_to_file("res://main.tscn")

func update_total_score(new_score: int):
	score_label.text = "Score: %d" % new_score
	

func weighted_random(items: Array) -> PowerUp:
	var total := 0
	for p in items:
		total += p.rarity_weight
	
	var roll := randi_range(0, total -1)
	var acc := 0
	
	for p in items:
		acc += p.rarity_weight 
		if roll < acc:
			return p
	
	return items[0]


func show_cant_afford():
	if cant_afford_popup.visible:
		return
	
	cant_afford_popup.visible = true
	cant_afford_popup.modulate.a = 1
	
	shake_node(cant_afford_popup)
	
	var tween := create_tween()
	tween.tween_interval(.3)
	tween.tween_property(
		cant_afford_popup, 
		"modulate:a", 
		0.0,
		 0.2
	)
	tween.finished.connect(func():
		cant_afford_popup.visible = false
	)

func shake_node(node: Control, strength:= 10, shakes:=6, speed:=0.05):
	var tween := create_tween()
	var original_pos := node.position
	
	for i in range(shakes):
		var offset := strength if i %2 == 0 else -strength
		tween.tween_property(
			node,
			"position",
			original_pos + Vector2(offset,0),
			speed
		)
		tween.tween_property(
			node,
			"position",
			original_pos,
			speed
			
		)
