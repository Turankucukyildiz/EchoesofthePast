extends Node

var recording = []
var is_recording: bool
var is_manual_recording := false

func on_record():
	if not GameManager.player_phase:
		return

	if not is_recording:
		is_recording = true

	is_manual_recording = true
	recording.clear()

func on_stop():
	if not GameManager.player_phase:
		return

	is_manual_recording = false
	is_recording = false

func record(pos: Vector2, vel: Vector2):
	if not is_recording:
		return

	recording.append({
		"pos": pos,
		"vel": vel})
