extends Control

#onready
@onready var rect := $VHS

#intaizltion
func _ready() -> void:
	SettingsManager.vhs_toggled.connect(_on_vhs_toggled)
	_on_vhs_toggled(SettingsManager.vhs_mode)

#out sourced buttons
func _on_vhs_toggled(value):
	rect.visible = value
func _on_settings_changed():
	visible = SettingsManager.vhs_mode
