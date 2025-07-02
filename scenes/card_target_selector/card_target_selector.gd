extends Node2D

const ARC_POINTS := 10

@onready var area2d: Area2D = $Area2D
@onready var card_arc: Line2D = $CanvasLayer/CardArc

var current_card: CardUI
var targeting := false


func _ready() -> void:
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)

func _process(_delta: float) -> void:
	if not targeting:
		return
	
	area2d.position = get_global_mouse_position()
	card_arc.points = _get_points()

func _get_points() -> Array:
	var points := []
	var start := current_card.global_position
	start.x += current_card.size.x /2
	var target := get_local_mouse_position()
	var distance := target - start
	
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS) * i
		var x := start.x + (distance.x / ARC_POINTS) * i
		var y := start.y + ease(t, 0.35) * distance.y
		points.append(Vector2(x, y))
	
	points.append(target)
	
	return points

func _on_card_aim_started(card: CardUI) -> void:
	if not card.card.is_single_targeted():
		return
	
	targeting = true
	area2d.monitoring = true
	area2d.monitorable = true
	current_card = card

func _on_card_aim_ended(_card: CardUI) -> void:
	targeting = false
	card_arc.clear_points()
	area2d.position = Vector2.ZERO
	area2d.monitoring = false
	area2d.monitorable = false
	current_card = null

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not current_card or not targeting:
		return
	
	if not current_card.targets.has(area):
		current_card.targets.append(area)
		current_card.request_tooltip()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if not current_card or not targeting:
		return
	
	current_card.targets.erase(area)
	current_card.request_tooltip()
