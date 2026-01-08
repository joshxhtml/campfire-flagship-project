extends CanvasLayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_resume_pressed() -> void:
	print("[PASUE] Resume Pressed")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameManager.resume_game()

func _on_save_run_pressed() -> void:
	GameManager.save_run()

func _on_quit_pressed() -> void:
	print("Quit to menu (not implemented)")
