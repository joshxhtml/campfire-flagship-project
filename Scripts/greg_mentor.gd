extends Control

#onreadys
@onready var greg := $GregSprite
@onready var greg_text := $GregText

#exports
@export var cooldown := 1.2

#enums
enum Emotion {
	NUETRAL,
	HAPPY,
	DISAPPOINTED,
	ZESTY,
	CONFUSED}
enum GregEvent {
	SHOT_MADE,
	SHOT_MISSED,
	HIT_100,
	RANDOM}

#emotions and phrases
var emotions := {
	Emotion.NUETRAL: preload("res://Greg/greg_neutral.png"),
	Emotion.HAPPY: preload("res://Greg/greg_happy.png"),
	Emotion.DISAPPOINTED: preload("res://Greg/greg_disappointed.png"),
	Emotion.ZESTY: preload("res://Greg/greg_zesty.png"),
	Emotion.CONFUSED: preload("res://Greg/greg_w_h_a_t.png")}
var greg_phrases := {
	GregEvent.SHOT_MADE: [
		{"text": "Nice Shot!", "emotion": Emotion.HAPPY },
		{"text": "That'll do!", "emotion": Emotion.HAPPY },
		{"text": "YIPPEE!", "emotion": Emotion.HAPPY },
		{"text": "You hit that!", "emotion": Emotion.HAPPY },
		{"text": "World's 2nd best player fr fr \n (behind me obviously)", "emotion": Emotion.HAPPY },
		{"text": "Catchphrase", "emotion": Emotion.ZESTY },
	],
	GregEvent.SHOT_MISSED: [
		{"text": "Nice Shot /s", "emotion": Emotion.DISAPPOINTED },
		{"text": "Let's just pretend you made that", "emotion": Emotion.CONFUSED },
		{"text": "aw", "emotion": Emotion.DISAPPOINTED},
		{"text": "better luck next time lmao", "emotion": Emotion.DISAPPOINTED },
		{"text": "you're worse than my 4 year old cousin", "emotion": Emotion.CONFUSED },
		{"text": "catchphrase (bad connotation)", "emotion": Emotion.ZESTY },
	],
	GregEvent.HIT_100: [
		{"text": "damn ok", "emotion": Emotion.ZESTY },
		{"text": "i do that daily, you aren't special", "emotion": Emotion.CONFUSED },
		{"text": "holy peak", "emotion": Emotion.HAPPY},
		{"text": "catchphrase (surpised connotation)", "emotion": Emotion.CONFUSED },
	],
	GregEvent.RANDOM: [
		{"text": "I believe in you, mostly", "emotion": Emotion.NUETRAL },
		{"text": "they live beyond the walls of this bar", "emotion": Emotion.CONFUSED },
		{"text": "the machine fears you", "emotion": Emotion.CONFUSED},
		{"text": "thank god the dev took physics", "emotion": Emotion.CONFUSED },
	],
}

#vars
var can_talk := true

#intialization
func _ready() -> void:
	set_emotion(Emotion.NUETRAL)

#funcs
func say(event: GregEvent):
	if not can_talk:
		return
	
	if not greg_phrases.has(event):
		return
	
	var pool = greg_phrases[event]
	var line = pool.pick_random()
	
	set_emotion(line.emotion)
	show_text(line.text)
	start_cooldown()
func set_emotion(e: Emotion):
	greg.texture = emotions[e]
func show_text(t: String):
	greg_text.text = t
	greg_text.modulate.a = 1
	
	var tween := create_tween()
	tween.tween_interval(2.0)
	tween.tween_property(greg_text, "modulate:a", 0.0, 0.3)
func start_cooldown():
	can_talk = false
	var timer := get_tree().create_timer(cooldown)
	timer.timeout.connect(func(): can_talk = true)
