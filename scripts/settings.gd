extends Control

@onready var master_volume_slider: HSlider = $MarginContainer/Settings/AudioSettings/MasterVolumeSettings/MasterVolumeSlider

func _ready() -> void:
	master_volume_slider.value = GameManager.master_volume

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		queue_free()

func _on_master_volume_slider_value_changed(value: float) -> void:
	GameManager.master_volume = value
