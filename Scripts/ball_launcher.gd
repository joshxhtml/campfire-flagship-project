extends Node3D

@export var left_right_range := .5
@export var max_tilt := 40.0
@export var max_power := 15.0
@export var power_charge_speed := 15.0
@onready var power_bar = get_node("../UI/HUD/PowerBar")

@export var min_launch_force := 8.0
@export var max_launch_force := 28.0

var position_input := 0.0
var tilt_input := 0.0
var power := 0.0 
var tilt_mode := false
var charging := false



@export var ball_scene: PackedScene

@export var aim_line_lenght := 6.0


@onready var aim_line := $AimLine


func update_aim_line():
	var mesh := ImmediateMesh.new()
	
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	if tilt_mode:
		material.albedo_color = Color(0.2, 0.5, 1.0) 
	else:
		material.albedo_color = Color(1.0, 0.2, 0.2) 
		
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	var start := Vector3.ZERO
	var direction := -transform.basis.z.normalized()
	var end := direction * aim_line_lenght
	
	mesh.surface_add_vertex(start)
	mesh.surface_add_vertex(end)
	
	mesh.surface_end()
	
	$AimLine.mesh = mesh

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
	power_bar.value = power * 100.0
	if Input.is_action_pressed("shoot"):
		charging = true
		power = min(power + delta * 0.8, 1.0)
	elif charging:
		shoot_ball()
		charging = false
		power = 0.0
	
	update_aim_line()

func shoot_ball():
	if GameManager.state != GameManager.GameState.PLAYING:
		return
	if not GameManager.can_shoot():
		return
	
	GameManager.use_ball()
	
	var ball = ball_scene.instantiate()
	get_parent().add_child(ball)
	ball.global_position = global_position
	
	var direction = -global_transform.basis.z.normalized()
	
	var launch_force = lerp(min_launch_force, max_launch_force, power)
	ball.apply_impulse(direction * launch_force)
	print("Launch force:", launch_force)
	
	power = 0.0
