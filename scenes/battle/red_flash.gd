extends CanvasLayer

@onready var color: ColorRect = $ColorRect
@onready var timer: Timer = $Timer

func _ready() -> void:
	Events.player_hit.connect(_on_player_hit)
	timer.timeout.connect(_on_timer_timeout)

func _on_player_hit() -> void:
	color.visible = true
	timer.start()

func _on_timer_timeout() -> void:
	color.visible = false
