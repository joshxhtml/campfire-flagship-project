extends Sprite2D

@export var hole_id: String

func _ready() -> void:
	add_to_group("map")
	visible = false
	
