extends RigidBody2D

var at_top_border:= false

func _process(_delta: float) -> void:
	if position.y < 488:
		position.y = 488
		set_deferred("freeze", true)

func on_button_pressed():
	set_deferred("freeze", false)
	gravity_scale = -0.5

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_deferred("freeze", false)
		gravity_scale = 0.5

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if freeze:
			set_deferred("freeze", false)

		if not at_top_border:
			gravity_scale = -0.5
