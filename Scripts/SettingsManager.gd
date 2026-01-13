extends Node

signal settings_changed
signal vhs_toggled(on)

const WIDTH := 1152
const HEIGHT := 648

var master_volume := 1
var vhs_mode := true
var fullscreen := false

func _ready() -> void:
	apply_all()

func apply_all():
	apply_volume()
	apply_vhs()
	apply_fullscreen()
	emit_signal("settings_changed")
	
func apply_volume():
	#stole this code btw, idk how audio works but i want to make a polished game, i may need to add autio first too 💀💀
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	
func apply_vhs():
	pass
	
func apply_fullscreen():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(WIDTH, HEIGHT))
		
func set_volume(value: float):
	master_volume = clamp(value, 0.0, 1.0)
	apply_volume()
	
func set_vhs(value: bool):
	if vhs_mode == value:
		return
	vhs_mode = value
	emit_signal("vhs_toggled", vhs_mode)

func set_fullscreen(value: bool):
	fullscreen = value
	apply_fullscreen()
