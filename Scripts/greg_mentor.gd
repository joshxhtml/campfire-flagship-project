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
	RANDOM,
	ROUND_START,
	GAMEOVER}

#emotions and phrases
var emotions := {
	Emotion.NUETRAL: preload("res://Greg/greg_neutral.png"),
	Emotion.HAPPY: preload("res://Greg/greg_happy.png"),
	Emotion.DISAPPOINTED: preload("res://Greg/greg_disappointed.png"),
	Emotion.ZESTY: preload("res://Greg/greg_zesty.png"),
	Emotion.CONFUSED: preload("res://Greg/greg_w_h_a_t.png")}
var greg_phrases := {
	GregEvent.SHOT_MADE: [
		{"text": "nice shot!", "emotion": Emotion.HAPPY },
		{"text": "that'll do!", "emotion": Emotion.HAPPY },
		{"text": "YIPPEE!", "emotion": Emotion.HAPPY },
		{"text": "you hit that!", "emotion": Emotion.HAPPY },
		{"text": "world's 2nd best player fr fr \n (behind me obviously)", "emotion": Emotion.HAPPY },
		{"text": "catchphrase", "emotion": Emotion.ZESTY },
		{"text": "you did it", "emotion": Emotion.HAPPY },
		{"text": "maybe i was wrong about you", "emotion": Emotion.HAPPY },
		{"text": "maybe you can be good at this", "emotion": Emotion.HAPPY },
		{"text": "your like a son to me", "emotion": Emotion.HAPPY },
		{"text": "gonna go pro in no time", "emotion": Emotion.HAPPY },
		{"text": "catchphrase2", "emotion": Emotion.ZESTY },
	],
	GregEvent.SHOT_MISSED: [
		{"text": "nice shot /s", "emotion": Emotion.DISAPPOINTED },
		{"text": "let's just pretend you made that", "emotion": Emotion.CONFUSED },
		{"text": "aw", "emotion": Emotion.DISAPPOINTED},
		{"text": "better luck next time lmao", "emotion": Emotion.DISAPPOINTED },
		{"text": "you're worse than my 4 year old cousin", "emotion": Emotion.CONFUSED },
		{"text": "catchphrase (bad connotation)", "emotion": Emotion.ZESTY },
		{"text": "L", "emotion": Emotion.DISAPPOINTED },
		{"text": "remember when i said you where like a son to me, disregaurd that now", "emotion": Emotion.CONFUSED },
		{"text": ":(", "emotion": Emotion.DISAPPOINTED},
		{"text": "i couldve made that", "emotion": Emotion.DISAPPOINTED },
		{"text": "tsk tsk tsk", "emotion": Emotion.CONFUSED },
		{"text": "what are we even doing", "emotion": Emotion.ZESTY },
	],
	GregEvent.HIT_100: [
		{"text": "damn ok", "emotion": Emotion.ZESTY },
		{"text": "i do that daily, you aren't special", "emotion": Emotion.CONFUSED },
		{"text": "holy peak", "emotion": Emotion.HAPPY},
		{"text": "catchphrase (surpised connotation)", "emotion": Emotion.CONFUSED },
	],
	GregEvent.RANDOM: [
		{"text": "i believe in you, mostly", "emotion": Emotion.NUETRAL },
		{"text": "they live beyond the walls of this bar", "emotion": Emotion.CONFUSED },
		{"text": "the machine fears you", "emotion": Emotion.CONFUSED},
		{"text": "hi mom", "emotion": Emotion.NUETRAL },
		{"text": "sometimes i feel like the world is going too fast for me", "emotion": Emotion.CONFUSED },
		{"text": "hack.club/jay", "emotion": Emotion.CONFUSED},
		{"text": ":3", "emotion": Emotion.CONFUSED },
	],
	GregEvent.ROUND_START: [
		{"text": "here we go again", "emotion": Emotion.NUETRAL },
		{"text": "well well well", "emotion": Emotion.CONFUSED },
		{"text": "this will surely be a round ", "emotion": Emotion.CONFUSED},
		{"text": "congrats on making it this far, or not, idk how far you are", "emotion": Emotion.CONFUSED },
	],
	GregEvent.GAMEOVER: [
		{"text": "ggs", "emotion": Emotion.DISAPPOINTED },
		{"text": "the end", "emotion": Emotion.CONFUSED },
		{"text": "you suck lmao", "emotion": Emotion.CONFUSED},
		{"text": "bye bye", "emotion": Emotion.CONFUSED },
	],
}

#vars
var can_talk := true
var tween : Tween = null

#intialization
func _ready() -> void:
	set_emotion(Emotion.NUETRAL)
	greg_text.text = ""
	
	GameManager.greg_shot_made.connect(_on_shot_made)
	GameManager.greg_shot_missed.connect(_on_shot_missed)
	GameManager.greg_hit_100.connect(_on_hit_100)
	GameManager.greg_random.connect(_on_random)
	GameManager.greg_round_start.connect(_on_round_start)
	GameManager.greg_game_over.connect(_on_game_over)

#pseaking logic
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
func better_say(event: GregEvent):
	can_talk = true
	say(event)
func set_emotion(e: Emotion):
	greg.texture = emotions[e]
func show_text(t: String):
	
	if tween and tween.is_running():
		tween.kill()
		
	greg_text.text = t
	greg_text.modulate.a = 1
	
	tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_property(greg_text, "modulate:a", 0.0, 0.3)
	tween.finished.connect(func(): greg_text.text = "")
func start_cooldown():
	can_talk = false
	var timer := get_tree().create_timer(cooldown)
	timer.timeout.connect(func(): can_talk = true)

#triggers
func _on_shot_made():
	say(GregEvent.SHOT_MADE)
func _on_shot_missed():
	say(GregEvent.SHOT_MISSED)
func _on_hit_100():
	say(GregEvent.HIT_100)
func _on_random():
	say(GregEvent.RANDOM)
func _on_round_start():
	better_say(GregEvent.ROUND_START)
func _on_game_over():
	set_emotion(Emotion.DISAPPOINTED)
	say(GregEvent.GAMEOVER)

#stop
func _exit_tree():
	if GameManager.greg_shot_made.is_connected(_on_shot_made):
		GameManager.greg_shot_made.disconnect(_on_shot_made)
		GameManager.greg_shot_missed.disconnect(_on_shot_missed)
		GameManager.greg_hit_100.disconnect(_on_hit_100)
		GameManager.greg_random.disconnect(_on_random)
		GameManager.greg_round_start.disconnect(_on_round_start)
		GameManager.greg_game_over.disconnect(_on_game_over)
