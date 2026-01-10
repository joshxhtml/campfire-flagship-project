extends AnimatedSprite3D

@export var normal: Array[SpriteFrames]
@export var rare: Array[SpriteFrames]

@export var chance:= 100
@export var cycle_time := 2.0

var cycle_timer:= 0.0

func _ready() -> void:
	randomize()
	pick_sprite()

func _process(delta: float) -> void:
	cycle_timer += delta
	if cycle_timer >= cycle_time:
		cycle_timer = 0.0
		pick_sprite()

func pick_sprite():
	if randi() % chance == 0 and rare.size() > 0:
		sprite_frames = rare.pick_random()
	else:
		sprite_frames = normal.pick_random()
	play("default")
