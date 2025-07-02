class_name SelfDamageEffect
extends Effect

var amount := 0


func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Player:
			target.take_damage(amount, Modifier.Type.NO_MODIFIER)
			SfxPlayer.play(sound)
