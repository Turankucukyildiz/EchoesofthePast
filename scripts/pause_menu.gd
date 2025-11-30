extends CanvasLayer

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	GameManager.is_playing = false

func _on_resume_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	var master_db = linear_to_db(GameManager.master_volume)
	audio_stream_player_2d.stream = preload("res://sounds/uibuttonpress.wav")
	audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
	audio_stream_player_2d.play()
	get_tree().paused = false
	GameManager.is_playing = true
	queue_free()

func _on_restart_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	var master_db = linear_to_db(GameManager.master_volume)
	audio_stream_player_2d.stream = preload("res://sounds/uibuttonpress.wav")
	audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
	audio_stream_player_2d.play()
	get_tree().paused = false
	GameManager.is_playing = true
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	var master_db = linear_to_db(GameManager.master_volume)
	audio_stream_player_2d.stream = preload("res://sounds/uibuttonpress.wav")
	audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
	audio_stream_player_2d.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
