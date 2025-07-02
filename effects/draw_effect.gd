class_name DrawEffect
extends Effect

var amount: int

func execute(_targets: Array[Node]) -> void:
	for i in amount:
		Events.draw_card.emit()
