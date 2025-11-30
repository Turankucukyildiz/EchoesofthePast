extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var replay_data = []
var current_frame := 0
var playerPos: Vector2
var speed_multiplier := 1

var shake_time := 0.0
var shake_strength := 0.0

func _ready() -> void:
	add_to_group("Ghost")
	start_shake(8.0, 0.3)
	var length = ReplayRecorder.recording.size()
	var pitch = 1.0 + clamp(length / 200.0, 0, 0.5)
	var volume = -10 + clamp(length / 50.0, 0, 10)
	var master_db = linear_to_db(GameManager.master_volume)
	audio_stream_player_2d.stream = preload("res://sounds/echo.wav")
	audio_stream_player_2d.pitch_scale = pitch
	audio_stream_player_2d.volume_db = volume + master_db
	audio_stream_player_2d.play()

func start_replay(data, player_pos: Vector2):
	replay_data = data
	current_frame = 0
	playerPos = player_pos
	set_process(true)

func _process(_delta):
	if shake_time > 0:
		shake_time -= _delta
		var t = Time.get_ticks_msec() * 0.02

		camera_2d.offset = Vector2(
			sin(t * 1.6) * shake_strength,
			cos(t * 2.3) * shake_strength
		)
	else:
		camera_2d.offset = Vector2.ZERO

	if Input.is_action_pressed("key_w"):
		speed_multiplier = 2
	else:
		speed_multiplier = 1

	current_frame += speed_multiplier

	if current_frame >= replay_data.size():
		GameManager.player_phase = true
		ReplayRecorder.recording.clear()
		ReplayRecorder.is_recording = true
		ReplayRecorder.is_manual_recording = false
		queue_free()
		return

	var frame = replay_data[current_frame]

	var offset = frame["pos"] - replay_data[0]["pos"]
	global_position = playerPos + offset

	velocity = frame["vel"]

	if velocity.length() > 0.1:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

	var last_direction = 1

	if velocity.x > 0:
		last_direction = 1
	elif velocity.x < 0:
		last_direction = -1

	animated_sprite_2d.flip_h = last_direction < 0

func start_shake(strength: float, duration: float):
	shake_strength = strength
	shake_time = duration
