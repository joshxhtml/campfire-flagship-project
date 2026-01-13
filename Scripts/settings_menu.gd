extends CanvasLayer

@export var change_interval := 2.0
@onready var greg := $GregSprite
@onready var volume_slider := $Panel/Buttons/VolumeSlider
@onready var vhs_toggle := $Panel/Buttons/VHSToggler
@onready var fullscreen_toggle := $Panel/Buttons/FullScreenToggler

var emotions := []

enum Emotion {
	HAPPY,
	NEUTRAL,
	ANGRY,
	SAD,
	CONFUSED
}
func _ready():
	volume_slider.value = SettingsManager.master_volume
	vhs_toggle.button_pressed = SettingsManager.vhs_mode
	fullscreen_toggle.button_pressed = SettingsManager.fullscreen
	
	GameManager.state = GameManager.GameState.MENU
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	for e in Emotion.values():
		emotions.append(e)
		
	randomize()
	_cycle_emotion()

func _cycle_emotion():
	while true:
		await get_tree().create_timer(change_interval).timeout
		var emotion = emotions.pick_random()
		greg.set_emotion(emotion)


func _on_volume_slider_value_changed(value: float) -> void:
	SettingsManager.set_volume(value)

func _on_vhs_toggler_toggled(toggled_on: bool) -> void:
	SettingsManager.set_vhs(toggled_on)

func _on_full_screen_toggler_toggled(toggled_on: bool) -> void:
	SettingsManager.set_fullscreen(toggled_on)

func _on_exit_pressed() -> void:
	queue_free()
