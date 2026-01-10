extends CanvasLayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
