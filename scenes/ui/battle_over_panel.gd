class_name BattleOverPanel
extends Panel

const MAIN_MENU := preload("res://scenes/ui/main_menu.tscn")

enum Type {WIN, LOSE}

@onready var label_big: Label = %Label
@onready var label_smol: Label = %Label2
@onready var continue_button: Button = %ContinueButton
@onready var menu_button: Button = %MainMenuButton


func _ready() -> void:
	continue_button.pressed.connect(func (): Events.battle_won.emit())
	menu_button.pressed.connect(get_tree().change_scene_to_packed.bind(MAIN_MENU))
	Events.battle_over_screen_requested.connect(show_screen)

func show_screen(text1: String, text2: String, type: Type) -> void:
	label_big.text = text1
	label_smol.text = text2
	continue_button.visible = type == Type.WIN
	menu_button.visible = type == Type.LOSE
	show()
	get_tree().paused = true
