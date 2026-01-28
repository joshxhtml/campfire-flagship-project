extends TextureRect

#exports
@export var happy_texture: Texture2D
@export var neutral_texture: Texture2D
@export var angry_texture: Texture2D
@export var sad_texture: Texture2D
@export var confused_texture: Texture2D
@export var zesty_texture: Texture2D

#enum emotions
enum Emotion {
	HAPPY,
	NEUTRAL,
	ANGRY,
	SAD,
	CONFUSED,
	ZESTY
}

#one and only core func
func set_emotion(emotion: int) -> void:
	match emotion:
		Emotion.HAPPY:
			texture = happy_texture
		Emotion.NEUTRAL:
			texture = neutral_texture
		Emotion.ANGRY:
			texture = angry_texture
		Emotion.SAD:
			texture = sad_texture
		Emotion.CONFUSED:
			texture = confused_texture
		Emotion.ZESTY:
			texture = zesty_texture
