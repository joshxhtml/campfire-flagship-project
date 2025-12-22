extends Node3D

@export var move_range := 1
@export var tilt_min := -5
@export var tilt_max := -10

@onready var pivot = $Pivot

var move_input := 0.0
var tilt_input := 0.0

func _process(delta: float) -> void:
	move_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	position.x = clamp(position.x + move_input * delta * 2.0, -move_range, move_range)
	
	var t = abs(position.x) / move_range
	var tilt = lerp(tilt_min, tilt_max, t)
	pivot.rotation_degrees.x = tilt
