extends Card

var heal_amount := 2

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var heal_effect := HealEffect.new()
	heal_effect.amount = heal_amount
	heal_effect.sound = sound
	heal_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % heal_amount

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text % heal_amount
