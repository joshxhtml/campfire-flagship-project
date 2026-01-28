extends CanvasLayer

#signal
signal change(slide_id: String)

#const
const SLIDES := [
	{
		"id": "controls",
		"image": preload("res://tutorial_images/game_screen.png"),
		"text": "alirght listen up \nA / D or Left / Right to move the aim line. \nhold enter to charge you shot \n(extra: hit space and use W / S or Up / Down for more options)",
		"show_arrow": false,
		"show_points": false,
	},
	{
		"id": "round_goal",
		"image": preload("res://tutorial_images/round_goal_screen.png"),
		"text": "every round has a goal. \nhit it, or its over. \nits that simple",
		"show_arrow": true,
		"show_points": false,
	},
	{
		"id": "points",
		"image": null,
		"text": "some holes \nare more \nequal than \nother holes",
		"show_arrow": false,
		"show_points": true,
	},
	{
		"id": "shop",
		"image": preload("res://tutorial_images/shop_screen.png"),
		"text": "every 5 rounds a shop opens \npowerups can help, mostly \nrerolls cost 50 \nchoose wisely",
		"show_arrow": false,
		"show_points": false,
	},
	{
		"id": "advanced",
		"image": preload("res://tutorial_images/locked_hole_screen.png"),
		"text": "after round 5...\nand every 5 rounds afyer that...\nholes start locking themselves\nhopefully you planned ahead",
		"show_arrow": false,
		"show_points": false,
	},
	{
		"id": "final",
		"image": null,
		"text": "thats all i got\ngood luck\nyour gonna need it\n\ntip from the dev: the best powerup is first/last ball\n another note from the dev: thanks for playing my game!!",
		"show_arrow": false,
		"show_points": false,
	},
]

#every onready ever in the world ever
@onready var ui := $"."
@onready var panel := $Panel
@onready var image := $Panel/TutorialImage
@onready var text_label := $Panel/GregText
@onready var arrow := $Panel/Arrow
@onready var points := $Panel/Points
@onready var next_button := $Panel/next
@onready var skip_button := $Panel/skip

#vars
var index := 0
var tween : Tween
var tween2: Tween
var speed := 0.03

#intialization
func _ready():
	start(0)

#funcs
func start(num: int):
	index = num
	var slide = SLIDES[num]
	emit_signal("change", slide.id)
	arrow.visible = slide.show_arrow
	points.visible = slide.show_points
	
	if slide.image:
		image.visible = true
		image.texture = slide.image
		image.modulate.a = 0
		fade_in()
	else:
		image.visible = false
	type_text(slide.text)
	
	
func fade_in():
	if tween2:
		tween2.kill()
	tween2 = create_tween()
	tween2.tween_property(image, "modulate:a", 1.0, 0.4)

func type_text(text1: String):
	if tween:
		tween.kill()
	
	text_label.text = ""
	var count := text1.length()
	tween = create_tween()
	#stole this code lmao
	for i in range(count):
		tween.tween_callback(func(): text_label.text += text1[i])
		tween.tween_interval(speed)

func end():
	GameManager.restart_run()
	get_tree().change_scene_to_file("res://main.tscn")
#buttons
func _on_next_pressed() -> void:
	if index >= SLIDES.size() - 1:
		end()
	else:
		start(index +1)
func _on_skip_pressed() -> void:
	GameManager.restart_run()
	get_tree().change_scene_to_file("res://main.tscn")
