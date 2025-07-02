# meta-name: Relic
# meta-description: Create a Relic which can be aqcuired by the player
extends Relic

var member_var := 0


func initialize_relic(_owner: RelicUI) -> void:
	print("If you're seeing this you may have forgotten to make the script for the relic %s" % id)

func activate_relic(_owner: RelicUI) -> void:
	print("If you're seeing this you may have forgotten to make the script for the relic %s" % id)

func deactivate_relic(_owner: RelicUI) -> void:
	print("If you're seeing this you may have forgotten to make the script for the relic %s" % id)

func get_tooltip() -> String:
	return tooltip
