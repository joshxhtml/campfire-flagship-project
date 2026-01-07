extends Node3D

@export var time:= 2.0
@export var trans_time:= 1.0

var colors:= [ Color.BLUE, Color.GREEN, Color.RED]
var current_index := 0
var tween: Tween

func _ready() -> void:
	GameManager.round_score_changed.connect(on_score)
	cycle_lights()

func cycle_lights():
	while true:
		var color = colors[current_index]
		blend_to_color(color)
		
		current_index = (current_index + 1) % colors.size()
		await get_tree().create_timer(time).timeout

func blend_to_color(target: Color):
	if tween:
		tween.kill()
	tween = create_tween()
	
	for light in get_children():
		if light is Light3D:
			tween.tween_property(light, "light_color", target, trans_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func on_score(_score):
	pulse(Color.WHITE, 0.4)

func pulse(_pulse_color: Color, duration := 0.4):
	for light in get_children():
		if light is Light3D:
			var tween2 = create_tween()
			tween2.tween_property(light, "light_energy", light.light_energy * 1.6, duration)
			tween2.tween_property(light, "light_energy", light.light_energy, duration)
