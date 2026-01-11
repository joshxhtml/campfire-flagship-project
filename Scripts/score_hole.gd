extends Area3D

@export var points := 50
@export var hole_id: String
@export var is_top_row := false

@onready var mesh : MeshInstance3D = $Mesh

var locked := false

func _ready() -> void:
	add_to_group("scoring_hole")
	
	print("[HOLE READY]", hole_id, "instance:", get_instance_id())
	update_visuals()

func set_locked(value: bool):
	locked = value
	print("[HOLE SET] ", hole_id, ", locked =", value)
	update_visuals()

func update_visuals() -> void:
	mesh.visible = locked


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("ball"):
		return
	
	if locked:
		print("[HOLE] Locked hole hit:", hole_id)
		body.resolve()
		return
	
	GameManager.add_score(points, hole_id, is_top_row)
	body.resolve()
