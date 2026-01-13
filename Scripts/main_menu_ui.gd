extends CanvasLayer

const SETTINGS := preload("res://UI/settings_menu_ui.tscn")

@export var change_interval := 2.0
@onready var greg := $GregSprite

var emotions := []

enum Emotion {
	HAPPY,
	NEUTRAL,
	ANGRY,
	SAD,
	CONFUSED
}
func _ready():
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


func _on_play_pressed() -> void:
	GameManager.restart_run()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_settings_pressed() -> void:
	var settings = SETTINGS.instantiate()
	add_child(settings)
