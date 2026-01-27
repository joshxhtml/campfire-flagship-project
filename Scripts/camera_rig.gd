extends Node3D

#exports
@export var mouse_senseivity := 0.15
@export var max_leftright := 12.0
@export var max_updown := 8.0
@export var return_speed := 6.0

#vars
var leftright := 0.0
var updown := 0.0
var mouse_active := true

#intialzation
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _process(delta):
	rotation_degrees.y = lerp(rotation_degrees.y, leftright, return_speed * delta)
	rotation_degrees.x = lerp(rotation_degrees.x, updown, return_speed * delta)

#input
func _input(event):
	if event is InputEventMouseMotion and mouse_active:
		leftright -= event.relative.x * mouse_senseivity 
		updown -= event.relative.y * mouse_senseivity 
		leftright = clamp(leftright, -max_leftright, max_leftright)
		updown = clamp(updown, -max_updown, max_updown)
