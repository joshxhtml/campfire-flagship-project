extends RigidBody3D

#exports
@export var lifetime := 6.0 

#vars
var resolved := false

#intialization
func _ready():
	sleeping = false
	start_new_timeout()

#core ball funcs
func start_new_timeout():
	await get_tree().create_timer(lifetime).timeout
	if not resolved:
		GameManager.other_kind_of_miss()
		resolve()
func resolve():
	if resolved:
		return
	
	resolved = true
	GameManager.ball_resolved()
	queue_free()
