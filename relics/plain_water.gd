extends Relic

@export var base_healing := 5


func activate_relic(owner: RelicUI) -> void:
	var player := owner.get_tree().get_first_node_in_group("player") as Player
	if player:
		player.stats.heal(base_healing)
		owner.flash()
