extends EnemyAction

const WRATH_STATUS := preload("res://status_effects/wrath.tres")

@export var stacks_per_action := 5

var hp_treshold := 35
var uses := 0

func is_performable() -> bool:
	var hp_under_treshold := enemy.stats.health <= hp_treshold
	if uses == 0 or (hp_under_treshold and uses == 1):
		uses += 1
		return true
	
	return false

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var status_effect := StatusEffect.new()
	var wrath = WRATH_STATUS.duplicate()
	wrath.stacks = stacks_per_action
	status_effect.status = wrath
	status_effect.execute([enemy])
	
	SfxPlayer.play(sound)
	
	get_tree().create_timer(0.5, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
