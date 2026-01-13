extends CanvasLayer

signal closed

@onready var volume_slider := $Panel/Buttons/VolumeSlider
@onready var vhs_toggle := $Panel/Buttons/VHSToggler
@onready var fullscreen_toggle := $Panel/Buttons/FullScreenToggler


func _ready():
	volume_slider.value = SettingsManager.master_volume
	vhs_toggle.button_pressed = SettingsManager.vhs_mode
	fullscreen_toggle.button_pressed = SettingsManager.fullscreen
	
	GameManager.state = GameManager.GameState.MENU
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_volume_slider_value_changed(value: float) -> void:
	SettingsManager.set_volume(value)

func _on_vhs_toggler_toggled(toggled_on: bool) -> void:
	SettingsManager.set_vhs(toggled_on)

func _on_full_screen_toggler_toggled(toggled_on: bool) -> void:
	SettingsManager.set_fullscreen(toggled_on)

func _on_exit_pressed() -> void:
	emit_signal("closed")
	queue_free()
