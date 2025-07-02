class_name CardVisuals
extends Control

@export var card: Card : set = set_card

@onready var panel := $Panel
@onready var cost := $Cost
@onready var icon := $Icon
@onready var rarity := $Rarity


func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	rarity.modulate = card.RARITY_COLORS[card.rarity]
