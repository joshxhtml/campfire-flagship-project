extends Panel

@onready var name_label = $Name
@onready var cost_label = $Cost
@onready var buy_label = $Buy

var powerup : PowerUp
var shop

func setup(p: PowerUp, shop_ref):
	powerup = p
	shop = shop_ref
	
	name_label.text = p.display_name
	cost_label.text = str(p.cost)
	
	buy_label.pressed.connect(_on_buy)

func _on_buy():
	shop.buy(powerup)
