extends CanvasLayer

#consts
const SETTINGS := preload("res://UI/settings_menu_ui.tscn")

#export
@export var change_interval := 2.0

#onready
@onready var greg := $GregSprite

#var
var emotions := []

#enum
enum Emotion {
	HAPPY,
	NEUTRAL,
	ANGRY,
	SAD,
	CONFUSED}

#intialzaiton
func _ready():
	GameManager.state = GameManager.GameState.MENU
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	for e in Emotion.values():
		emotions.append(e)
		
	randomize()
	_cycle_emotion()

#core funcs
func _cycle_emotion():
	while true:
		await get_tree().create_timer(change_interval).timeout
		var emotion = emotions.pick_random()
		greg.set_emotion(emotion)

#buttons
func _on_play_pressed() -> void:
	if not GameManager.tutorial:
		GameManager.tutorial = true
		get_tree().change_scene_to_file("res://UI/tutorial.tscn")
	else:
		GameManager.restart_run()
		get_tree().change_scene_to_file("res://main.tscn")
func _on_settings_pressed() -> void:
	var settings = SETTINGS.instantiate()
	add_child(settings)
