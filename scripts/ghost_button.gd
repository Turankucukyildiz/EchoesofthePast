extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var object_path: NodePath
var object

func _ready() -> void:
	object = get_node(object_path)
	hide()

func _process(_delta: float) -> void:
	if not GameManager.player_phase:
		show()
	else:
		hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ghost"):
		animated_sprite_2d.play("on")
		var master_db = linear_to_db(GameManager.master_volume)
		audio_stream_player_2d.stream = preload("res://sounds/gamebuttonpress.wav")
		audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
		audio_stream_player_2d.play()
		object.on_button_pressed()
