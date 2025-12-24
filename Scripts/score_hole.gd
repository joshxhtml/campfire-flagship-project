extends Area3D

@export var score_value := 50

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("ball"):
		GameManager.add_score(score_value)
		body.resolve()
