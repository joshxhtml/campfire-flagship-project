extends Node3D

@export var spin_speed := 60.0
@export var spin_axis := Vector3.UP

func _process(delta: float) -> void:
	rotate(spin_axis, deg_to_rad(spin_speed) * delta)
