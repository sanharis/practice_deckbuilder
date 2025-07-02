# meta-name: Status
# meta-description: Create a status that can be applied to a target
class_name SomeStatus
extends Status

var member_var := 0


func initialize_status(target: Node) -> void:
	pass

func apply_status(target: Node) -> void:
	status_applied.emit(self)
