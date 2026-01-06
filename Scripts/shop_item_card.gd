extends Panel
signal purchased(powerup: PowerUp)

@export var powerup: PowerUp
@onready var buy_button := $Buy

var bought := false

func setup(p: PowerUp):
	powerup = p
	$Icon.texture = powerup.icon
	$Name.text = p.display_name
	$Description.text = p.description
	$Cost.text = "Cost: %d" % p.cost
	

func _on_buy_pressed() -> void:
	print("buy pressed:", powerup.id)
	if bought:
		return
		
	
	purchased.emit(powerup)
