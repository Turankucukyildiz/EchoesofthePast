extends Control

@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_play_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	var master_db = linear_to_db(GameManager.master_volume)
	audio_stream_player_2d.stream = preload("res://sounds/uibuttonpress.wav")
	audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
	audio_stream_player_2d.play()

	var tween = create_tween()
	tween.tween_property(
		camera_2d, 
		"zoom", 
		Vector2(2.5, 2.5), 
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await tween.finished

	GameManager.is_playing = true
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_settings_pressed() -> void:
	var master_db = linear_to_db(GameManager.master_volume)
	audio_stream_player_2d.stream = preload("res://sounds/uibuttonpress.wav")
	audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
	audio_stream_player_2d.play()
	var settings = preload("res://scenes/UI/settings.tscn").instantiate()
	add_child(settings)

func _on_quit_pressed() -> void:
	var master_db = linear_to_db(GameManager.master_volume)
	audio_stream_player_2d.stream = preload("res://sounds/uibuttonpress.wav")
	audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
	audio_stream_player_2d.play()
	get_tree().quit()
