class_name StatusHandler
extends GridContainer

signal statuses_applied(type: Status.Type)

const STATUS_APPLY_INTERVAL := 0.2
const STATUS_UI := preload("res://scenes/status_handler/status_ui.tscn")

@export var status_owner: Node2D


func apply_statuses_by_type(type: Status.Type) -> void:
	if type == Status.Type.EVENT_BASED:
		return
	
	var status_queue: Array[Status] = _get_all_stati().filter(
		func(status: Status):
			return status.type == type
	) 
	if status_queue.is_empty():
		statuses_applied.emit(type)
		return
	
	var tween := create_tween()
	for status: Status in status_queue:
		tween.tween_callback(status.apply_status.bind(status_owner))
		tween.tween_interval(STATUS_APPLY_INTERVAL)
	
	tween.finished.connect(func(): statuses_applied.emit(type))

func add_status(status: Status) -> void:
	var stackable := status.stack_type != Status.StackType.NONE
	
	#if it's new
	if not _has_status(status.id):
		var new_status_ui := STATUS_UI.instantiate() as StatusUI
		add_child(new_status_ui)
		new_status_ui.status = status.duplicate()
		new_status_ui.status.status_applied.connect(_on_status_applied)
		new_status_ui.status.initialize_status(status_owner)
		return
	
	#if it's unique and non-stackable
	if not status.can_expire and not stackable:
		return
	
	#if it's reapplying
	if status.can_expire and status.stack_type == Status.StackType.DURATION:
		_get_status(status.id).duration += status.duration
		return
		
	if status.stack_type == Status.StackType.INTENSITY:
		_get_status(status.id).stacks += status.stacks


func _has_status(id: String) -> bool:
	for statusui: StatusUI in get_children():
		if statusui.status.id == id:
			return true
	
	return false

func _get_status(id: String) -> Status:
	for statusui: StatusUI in get_children():
		if statusui.status.id == id:
			return statusui.status
	
	return null

func _get_all_stati() -> Array[Status]:
	var stati: Array[Status] = []
	for statusui: StatusUI in get_children():
		stati.append(statusui.status)
	
	return stati

func _on_status_applied(status: Status) -> void:
	if status.can_expire:
		status.duration -= 1


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		Events.status_tooltip_requested.emit(_get_all_stati())
