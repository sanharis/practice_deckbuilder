class_name DodgeEffect
extends Effect

var amount := 0

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.stats.dodge += amount
			target.sprite.modulate = Color(1,1,1,0.5)
			SfxPlayer.play(sound)
