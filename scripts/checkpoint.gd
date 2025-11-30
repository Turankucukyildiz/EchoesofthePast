extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_flag_out:= false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not is_flag_out:
		var master_db = linear_to_db(GameManager.master_volume)
		audio_stream_player_2d.stream = preload("res://sounds/checkpoint.wav")
		audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
		audio_stream_player_2d.play()
		is_flag_out = true
		GameManager.checkpoint_position = global_position
		animated_sprite_2d.play("flag_out")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "flag_out":
		animated_sprite_2d.play("flag_idle")
