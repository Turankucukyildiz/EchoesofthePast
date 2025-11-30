extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const JUMP_FORCE = -1000.0

@export var player_path : NodePath
var player
var active := false

func _ready() -> void:
	hide()
	collision_shape_2d.set_deferred("disabled", true)
	player = get_node(player_path)

func on_button_pressed():
	show()
	collision_shape_2d.set_deferred("disabled", false)
	active = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not active:
		return

	if body == player:
		audio_stream_player_2d.stream = preload("res://sounds/trampoline.wav")
		var master_db = linear_to_db(GameManager.master_volume)
		audio_stream_player_2d.volume_db = audio_stream_player_2d.volume_db + master_db
		audio_stream_player_2d.play()
		player.apply_bounce(JUMP_FORCE)
		animated_sprite_2d.play("jump")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "jump":
		animated_sprite_2d.play("idle")
