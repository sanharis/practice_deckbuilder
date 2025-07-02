class_name WinScreen
extends CanvasLayer

const MAIN_MENU_PATH := "res://scenes/ui/main_menu.tscn"

@export var run: Run : set = set_run
@export_multiline var message: String

var gold: int

@onready var message_label: Label = %Message
@onready var char_portrait: TextureRect = %CharPortrait


func set_run(new_run: Run) -> void:
	run = new_run
	message_label.text = message % str(run.stats.gold)
	char_portrait.texture = run.character.portrait

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
