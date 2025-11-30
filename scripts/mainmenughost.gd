extends AnimatedSprite2D

var speed := 100.0
var direction := 1

const LEFT_LIMIT := 1004.0
const RIGHT_LIMIT := 1268.0

func _process(delta: float) -> void:
	position.x += speed * direction * delta

	if position.x <= LEFT_LIMIT:
		position.x = LEFT_LIMIT
		direction = 1
		flip_h = false

	elif position.x >= RIGHT_LIMIT:
		position.x = RIGHT_LIMIT
		direction = -1
		flip_h = true
