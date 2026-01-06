extends Area3D

@export var points := 50
@export var hole_id: String
@export var is_top_row := false


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("ball"):
		GameManager.add_score(points, hole_id, is_top_row)
		body.resolve()
