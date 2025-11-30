extends Node

var player_can_move := false
var player_phase := false
var checkpoint_position : Vector2
var is_playing := false
var master_volume: float = 1.0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if is_playing:
			var pause_menu = preload("res://scenes/UI/pause_menu.tscn").instantiate()
			get_tree().current_scene.add_child(pause_menu)
