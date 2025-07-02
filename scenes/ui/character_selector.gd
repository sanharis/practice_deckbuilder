extends Control

const RUN_SCENE := preload("res://scenes/run/run.tscn")
const WARRIOR := preload("res://characters/warrior/warrior.tres")
const WIZARD := preload("res://characters/wizard/wizard.tres")

@export var run_startup : RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var char_portrait: TextureRect = %CharPortrait

var current_character : CharacterStats : set = set_current_character


func _ready() -> void:
	set_current_character(WARRIOR)


func set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	
	title.text = current_character.character_name
	description.text = current_character.description
	char_portrait.texture = current_character.portrait

func _on_start_pressed() -> void:
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.picked_character = current_character
	get_tree().change_scene_to_packed(RUN_SCENE)

func _on_warrior_button_pressed() -> void:
	current_character = WARRIOR

func _on_wizard_button_pressed() -> void:
	current_character = WIZARD
