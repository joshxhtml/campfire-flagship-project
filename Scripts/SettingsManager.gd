extends Node

#signals
signal settings_changed
signal vhs_toggled(on)

#consts
const WIDTH := 1152
const HEIGHT := 648

#vars
var master_volume := 1.0
var vhs_mode := true
var fullscreen := false

#intailzaiton
func _ready() -> void:
	apply_volume()
	apply_all()
func apply_all():
	apply_volume()
	apply_fullscreen()
	emit_signal("settings_changed")

#apply things
#thank you chatgpt
func apply_volume():
	var bus := AudioServer.get_bus_index("Master")

	if master_volume <= 0.001:
		AudioServer.set_bus_mute(bus, true)
		return

	AudioServer.set_bus_mute(bus, false)

	var curved := pow(master_volume, 0.1)
	var db := linear_to_db(curved)
	db = max(db, -60.0)

	AudioServer.set_bus_volume_db(bus, db)
func apply_fullscreen():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(WIDTH, HEIGHT))

#set things
func set_volume(value: float):
	master_volume = clamp(value, 0.0, 1.0)
	apply_volume()
func set_vhs(value: bool):
	if vhs_mode == value:
		return
	vhs_mode = value
	emit_signal("vhs_toggled", vhs_mode)
func set_fullscreen(_value: bool):
	#fullscreen = value
	#apply_fullscreen()
	pass
