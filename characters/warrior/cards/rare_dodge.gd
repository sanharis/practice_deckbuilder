extends Card

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var dodge_effect := DodgeEffect.new()
	dodge_effect.amount = 2
	dodge_effect.sound = sound
	dodge_effect.execute(targets)
