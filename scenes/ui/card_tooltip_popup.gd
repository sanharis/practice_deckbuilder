class_name CardTooltipPopup
extends Control

const CARD_MENU_UI_SCENE := preload("res://scenes/ui/card_menu_ui.tscn")

@export var background_color: Color = Color("00004664")

@onready var background: ColorRect = $Background
@onready var tooltip_card : CenterContainer = %TooltipCard
@onready var card_description : RichTextLabel = %CardDescription


func _ready() -> void:
	for card: CardMenuUI in tooltip_card.get_children():
		card.queue_free()
	
	background.color = background_color

func show_tooltip(card: Card) -> void:
	var new_card := CARD_MENU_UI_SCENE.instantiate() as CardMenuUI
	tooltip_card.add_child(new_card)
	new_card.visuals.custom_minimum_size = Vector2(50, 60)
	new_card.visuals.cost.position = Vector2(3, 3)
	new_card.visuals.cost.add_theme_font_size_override("font_size", 12)
	new_card.visuals.rarity.size = Vector2(10, 10)
	new_card.visuals.rarity.position = Vector2(13, 18)
	
	new_card.card = card
	new_card.tooltip_requested.connect(hide_tooltip.unbind(1))
	card_description.text = card.get_default_tooltip()
	show()

func hide_tooltip() -> void:
	if not visible:
		return
	
	for card: CardMenuUI in tooltip_card.get_children():
		card.queue_free()
	
	hide()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		hide_tooltip()
