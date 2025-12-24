extends Control

@onready var sprite := $GregSprite

enum Emotion {
	NUETRAL,
	HAPPY,
	DISAPPOINTED,
	ZESTY,
	CONFUSED
}

var emotions := {
	Emotion.NUETRAL: preload("res://Greg/greg_neutral.png"),
	Emotion.HAPPY: preload("res://Greg/greg_happy.png"),
	Emotion.DISAPPOINTED: preload("res://Greg/greg_disappointed.png"),
	Emotion.ZESTY: preload("res://Greg/greg_zesty.png"),
	Emotion.CONFUSED: preload("res://Greg/greg_w_h_a_t.png")
}

func _ready() -> void:
	set_emotion(Emotion.NUETRAL)
	
func set_emotion(e: Emotion):
	sprite.texture = emotions[e]
