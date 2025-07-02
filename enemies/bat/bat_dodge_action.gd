extends EnemyAction

@export var dodge := 1

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var dodge_effect := DodgeEffect.new()
	dodge_effect.amount = dodge
	dodge_effect.sound = sound
	dodge_effect.execute([enemy])
	
	get_tree().create_timer(0.5, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
