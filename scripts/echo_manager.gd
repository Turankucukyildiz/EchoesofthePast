extends Node

signal echo

var auto_timer = 0.0
var auto_interval = 10.0

func _process(delta):
	auto_timer += delta

	if auto_timer >= auto_interval:
		auto_timer = 0.0
		trigger_echo()

func trigger_echo():
	GameManager.player_phase = false
	ReplayRecorder.is_recording = false
	ReplayRecorder.is_manual_recording = false
	emit_signal("echo")
