extends Node3D

#onready
@onready var greg := $greglayer/GregSprite
@onready var tutorial := $tutorialUI

#intailization
func _ready() -> void:
	tutorial.change.connect(_on_slide_change)

func _on_slide_change(slide_id: String):
	match slide_id:
		"controls":
			greg.set_emotion(greg.Emotion.CONFUSED)
		"round_goal":
			greg.set_emotion(greg.Emotion.NEUTRAL)
		"points":
			greg.set_emotion(greg.Emotion.ZESTY)
		"shop":
			greg.set_emotion(greg.Emotion.HAPPY)
		"advanced":
			greg.set_emotion(greg.Emotion.CONFUSED)
		"final":
			greg.set_emotion(greg.Emotion.HAPPY)
