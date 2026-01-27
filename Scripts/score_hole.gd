extends Area3D

#exports
@export var points := 50
@export var hole_id: String
@export var is_top_row := false

#onreadys
@onready var mesh : MeshInstance3D = $Mesh

#var
var locked := false

#intialzation
func _ready() -> void:
	add_to_group("scoring_hole")
	
	#print("[HOLE READY]", hole_id, "instance:", get_instance_id())
	update_visuals()

#core funcs
func set_locked(value: bool):
	locked = value
	#print("[HOLE SET] ", hole_id, ", locked =", value)
	update_visuals()
func update_visuals() -> void:
	mesh.visible = locked

#triggers
func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("ball"):
		return
	
	if locked:
		#worlds longest line ever
		if GameManager.owned_powerups.has("second_chance") and not GameManager.used_second_chance:
			GameManager.used_second_chance = true
			body.resolve()
			return
		
		body.resolve()
		return
	
	GameManager.add_score(points, hole_id, is_top_row)
	body.resolve()
