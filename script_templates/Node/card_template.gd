# meta-name: Card logic
# meta-description: What happens when a card is played
extends Card

@export var optional_sound: AudioStream

func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	pass

func get_default_tooltip() -> String:
	return tooltip_text

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text
