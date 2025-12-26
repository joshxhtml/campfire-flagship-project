extends Panel
signal purchased(powerup)

var powerup: PowerUp

func setup(p: PowerUp):
	powerup = p
	$VBoxContainer/Name.text = p.display_name
	$VBoxContainer/Description.text = p.description
	$VBoxContainer/Cost.text = "Cost: %d" % p.cost

func _on_Buy_pressed():
	purchased.emit(powerup)
