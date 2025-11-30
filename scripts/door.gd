extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func on_button_pressed():
	animated_sprite_2d.play("open")
	collision_shape_2d.set_deferred("disabled", true)
