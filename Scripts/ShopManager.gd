extends CanvasLayer

@export var powerup_pool : Array[PowerUp]

var current_items : Array[PowerUp] = []

func _ready() -> void:
	randomize()
	current_items = pick_random_powerups(3)
	show_items()
	
func pick_random_powerups(count: int) -> Array[PowerUp]:
	var result: Array[PowerUp] = []
	for i in range(count):
		result.append(weighted_random(powerup_pool))
	return result

func show_items():
	print("Shop items:")
	for p in current_items:
		print(p.id, "cost:", p.cost)

func weighted_random(items: Array[PowerUp]) -> PowerUp:
	if items.is_empty():
		push_error("Powerup pool is empty dumbass")
		return null

	var total := 0
	for p in items:
		total += p.rarity_weight

	if total <= 0:
		push_error("All rarity weights are 0, that means your stupud fr fr")
		return items[0]

	var roll := randi() % total
	var acc := 0

	for p in items:
		acc += p.rarity_weight
		if roll < acc:
			return p

	return items[0]


func buy_powerups(powerup: PowerUp):
	if GameManager.total_score < powerup.cost:
		return
	
	GameManager.total_score -= powerup.cost
	GameManager.apply_powerup(powerup)
	exit_shop()
	
func exit_shop():
	get_tree().change_scene_to_file("res://main.tscn")
	GameManager.return_from_shop()
