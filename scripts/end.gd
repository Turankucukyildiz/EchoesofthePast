extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	sprite_2d.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		audio_stream_player_2d.stream = preload("res://sounds/checkpoint.wav")
		var master_db = linear_to_db(GameManager.master_volume)
		audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
		audio_stream_player_2d.play()
		GameManager.player_can_move = false
		EchoManager.auto_timer = 0.0
		ReplayRecorder.recording.clear()
		sprite_2d.show()
		animation_player.play("konfeti")
		animated_sprite_2d.play("pressed")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "pressed":
		var end_menu = preload("res://scenes/UI/end_menu.tscn").instantiate()
		get_tree().current_scene.add_child(end_menu)
