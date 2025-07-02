class_name Relic
extends Resource

enum Type {TURN_START, TURN_END, COMBAT_START, COMBAT_END, EVENT}
enum CharacterType {ALL, WARRIOR, WIZARD}

@export var relic_name: String
@export var id: String
@export var type: Type
@export var character_type: CharacterType
@export var starter: bool = false
@export var icon: Texture
@export_multiline var tooltip: String


func initialize_relic(_owner: RelicUI) -> void:
	pass

func activate_relic(_owner: RelicUI) -> void:
	pass

func deactivate_relic(_owner: RelicUI) -> void:
	pass


func get_tooltip() -> String:
	return tooltip

func can_appear_as_reward(character: CharacterStats) -> bool:
	if starter:
		return false
	
	if character_type == CharacterType.ALL:
		return true
	
	var relic_char_name: String = CharacterType.keys()[character_type].to_lower()
	var char_name := character.character_name.to_lower()
	
	return relic_char_name == char_name
