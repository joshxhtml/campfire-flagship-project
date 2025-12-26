extends Control

@export var powerup_pool: Array[PowerUp]
@export var reroll_cost := 50
@export var card_scene: PackedScene
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
var reroll_used := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cant_afford_popup.visible = false
	
	score_label.text =  "Score: %d" % GameManager.total_score
	GameManager.total_score_changed.connect(update_total_score)
	reroll_button.pressed.connect(_on_Reroll_pressed)
	exit_button.pressed.connect(_on_Exit_pressed)
	
	generate_items()


func generate_items():
	current_items.clear()
	reroll_button.disabled = reroll_used
	
	for slot in card_slots:
		for child in slot.get_children():
			child.queue_free()
	
	for i in range(card_slots.size()):
		var powerup = weighted_random(powerup_pool)
		current_items.append(powerup)
		
		var card = card_scene.instantiate()
		card.setup(powerup)
		card.purchased.connect(on_item_purchased)
		
		card_slots[i].add_child(card)

func on_item_purchased(powerup: PowerUp):
	if GameManager.total_score < powerup.cost:
		show_cant_afford()
		return
		
	GameManager.total_score -= powerup.cost
	
	GameManager.apply_powerup(powerup)
	exit_shop()



func _on_Reroll_pressed():
	if reroll_used:
		return
	if GameManager.total_score < reroll_cost:
		show_cant_afford()
		return

	GameManager.total_score -= reroll_cost
	
	reroll_used = true
	generate_items()

func _on_Exit_pressed():
	exit_shop()

func exit_shop():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	GameManager.allow_play()
	GameManager.start_round()
	
	get_tree().change_scene_to_file("res://main.tscn")

func weighted_random(items: Array) -> PowerUp:
	if items.is_empty():
		push_error("Shop pool empty dumbass")
		return null

	var total := 0
	for p in items:
		total += p.rarity_weight

	if total <= 0:
		push_error("All rarity weights are 0 so like, fix that fr fr")
		return items[0]

	var roll := randi_range(0, total - 1)
	var acc := 0

	for p in items:
		acc += p.rarity_weight
		if roll < acc:
			return p

	return items[0]

func update_total_score(value: int):
	score_label.text = "Score: %d" % value
	

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
