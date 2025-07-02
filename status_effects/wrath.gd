class_name WrathStatus
extends Status


func get_tooltip() -> String:
	return tooltip % stacks

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifier handler on %s" % target)
	
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "No dmg dealt modifier on %s" % target)
	
	var wrath_modifier_value := dmg_dealt_modifier.get_value("wrath")
	
	if not wrath_modifier_value:
		wrath_modifier_value = ModifierValue.create_new_modifier("wrath", ModifierValue.Type.FLAT)
	
	wrath_modifier_value.flat_value = stacks
	dmg_dealt_modifier.add_new_value(wrath_modifier_value)
	
	status_applied.emit(self)
