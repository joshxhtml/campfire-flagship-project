extends RigidBody3D

var resolved := false
@export var lifetime := 6.0 

func _ready():
	sleeping = false
	
	await get_tree().create_timer(lifetime).timeout
	if not resolved:
		resolve()

func resolve():
	if resolved:
		return
	
	resolved = true
	GameManager.ball_resolved()
	queue_free()
