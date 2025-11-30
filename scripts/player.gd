extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const JUMP_VELOCITY = -320.0
var speed = 200.0
var walk_speed = 200.0
var sprint_speed = 300.0

var shake_timer := 0.0
var shake_strength := 0.0

func _ready() -> void:
	add_to_group("Player")
	GameManager.player_can_move = true
	GameManager.player_phase = true
	ReplayRecorder.is_recording = true
	EchoManager.connect("echo", Callable(self, "_on_echo"))
	EchoManager.auto_timer = 0.0

func _process(delta: float) -> void:
	if shake_timer > 0:
		shake_timer -= delta

		var offset_y = randf_range(-1, 1) * shake_strength
		camera_2d.offset = Vector2(0, offset_y)

		shake_strength = lerp(shake_strength, 0.0, delta * 10)
	else:
		camera_2d.offset = Vector2.ZERO

	if Input.is_action_just_pressed("key_r") and not ReplayRecorder.is_manual_recording:
		ReplayRecorder.on_record()
		var master_db = linear_to_db(GameManager.master_volume)
		audio_stream_player_2d.stream = preload("res://sounds/record.wav")
		audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
		audio_stream_player_2d.play()

	if Input.is_action_just_pressed("key_s") and ReplayRecorder.is_manual_recording:
		ReplayRecorder.on_stop()
		var master_db = linear_to_db(GameManager.master_volume)
		audio_stream_player_2d.stream = preload("res://sounds/stop.wav")
		audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
		audio_stream_player_2d.play()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not GameManager.player_phase or not GameManager.player_can_move:
		return

	if not camera_2d.enabled:
		camera_2d.enabled = true

	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("shift"):
		speed = sprint_speed
	else:
		speed = walk_speed

	var direction := Input.get_axis("key_a", "key_d")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0

	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")

	else:
		if abs(velocity.x) > 10:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	
	if ReplayRecorder.is_recording:
		ReplayRecorder.record(global_position, velocity)

	move_and_slide()

func _on_echo():
	EchoManager.auto_timer = 0.0
	animated_sprite_2d.play("idle")
	var ghost = preload("res://scenes/ghost.tscn").instantiate()
	ghost.global_position = global_position
	get_tree().current_scene.add_child.call_deferred(ghost)

	ghost.start_replay(ReplayRecorder.recording, global_position)

	camera_2d.enabled = false

func _on_world_border_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var master_db = linear_to_db(GameManager.master_volume)
		audio_stream_player_2d.stream = preload("res://sounds/fall.wav")
		audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
		audio_stream_player_2d.play()
		EchoManager.auto_timer = 0.0
		ReplayRecorder.recording.clear()
		await audio_stream_player_2d.finished
		global_position = GameManager.checkpoint_position

func apply_bounce(force):
	velocity.y = force
	animated_sprite_2d.play("jump")

	shake_strength = 30.0
	shake_timer = 1.0
