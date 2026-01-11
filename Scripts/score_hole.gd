extends Area3D

@export var points := 50
@export var hole_id: String
@export var is_top_row := false

@onready var mesh : MeshInstance3D = $Mesh

var locked := false

func _ready() -> void:
	add_to_group("scoring_hole")
	if mesh == null:
		push_error("Hole %s id missing its meshInstance 3d" % hole_id)
		return 
	mesh.visible = false
	update_visuals()
	
func update_visuals():
	locked = GameManager.is_hole_locked(hole_id)
	mesh.visible = locked
	
		
func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("ball"):
		return
	
	if GameManager.is_hole_locked(hole_id):
		print("[HOLE] Locked hole hit:", hole_id)
		body.resolve()
		return
	
	GameManager.add_score(points, hole_id, is_top_row)
	body.resolve()
