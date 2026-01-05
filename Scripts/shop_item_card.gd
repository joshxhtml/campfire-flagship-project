extends Panel
signal purchased(powerup)

@export var powerup: PowerUp
@onready var buy_button := $Buy

var bought := false

func setup(p: PowerUp):
	powerup = p
	$Icon.texture = powerup.icon
	$Name.text = p.display_name
	$Description.text = p.description
	$Cost.text = "Cost: %d" % p.cost

func _on_Buy_pressed():
	if bought:
		return
		
	
	purchased.emit(powerup)	
