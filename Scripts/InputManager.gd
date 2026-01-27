extends Node

#input
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			GameManager.resume_game()
		else:
			GameManager.open_pause_menu()
