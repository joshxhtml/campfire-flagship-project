extends Control

func _ready() -> void:
	visible = SettingsManager.vhs_mode
	SettingsManager.settings_changed.connect(_on_settings_changed)

func _on_settings_changed():
	visible = SettingsManager.vhs_mode
