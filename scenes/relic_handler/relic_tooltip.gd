class_name RelicTooltip
extends Control

@onready var icon: TextureRect = %RelicIcon
@onready var tooltip: RichTextLabel = %RelicTooltip


func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide()


func show_tooltip(relic: Relic) -> void:
	icon.texture = relic.icon
	tooltip.text = relic.get_tooltip()
	show()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		hide()
