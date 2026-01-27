extends Sprite2D

#exports
@export var hole_id: String

#intialztion
func _ready() -> void:
	add_to_group("map")
	visible = false
