extends Node3D

@export var left_right_range := .5
@export var max_tilt := 15.0
@export var max_power := 30.0
@export var power_charge_speed := 20.0
@onready var power_bar = get_node("../PowerBar")

var position_input := 0.0
var tilt_input := 0.0
var power := 0.0
var tilt_mode := false
var charging := false

@export var ball_scene: PackedScene

func _process(delta):
	if Input.is_action_just_pressed("change_mode"):
		tilt_mode = !tilt_mode
		
	if tilt_mode:
		tilt_input += (Input.get_action_strength("tilt_up") - Input.get_action_strength("tilt_down")) * delta * 30.0
		tilt_input = clamp(tilt_input, -max_tilt, max_tilt)
	else:
		position_input += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * delta * 2.0
		position_input = clamp(position_input, -left_right_range, left_right_range)
		
	position.x = position_input
	rotation.z = deg_to_rad(-tilt_input)
	power_bar.value = power
	if Input.is_action_pressed("shoot"):
		charging = true
		power = min(power + power_charge_speed * delta, max_power)
	elif charging:
		shoot_ball()
		charging = false
		power = 0.0

func shoot_ball():
	print("ball shot")
	var ball = ball_scene.instantiate()
	get_parent().add_child(ball)
	print(ball)
	ball.global_position = global_position
	
	var direction = -global_transform.basis.z
	ball.apply_impulse(direction * power)
