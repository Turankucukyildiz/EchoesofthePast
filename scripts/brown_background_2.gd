extends TextureRect

@onready var area2d: Area2D = $Area2D

const DARK_COLOR := Color(0.5, 0.5, 0.5, 1.0)
const BRIGHT_COLOR := Color(1.0, 1.0, 1.0, 1.0)
const TWEEN_TIME := 0.2

func _ready() -> void:
	modulate = DARK_COLOR

func _tween_to_color(target: Color) -> void:
	var tw = get_tree().create_tween()
	tw.tween_property(self, "modulate", target, TWEEN_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_tween_to_color(BRIGHT_COLOR)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_tween_to_color(DARK_COLOR)
