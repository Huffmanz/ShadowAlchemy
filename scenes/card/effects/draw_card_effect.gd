class_name DrawCardEffect
extends Effect

@export var draw_amount := 1

func apply_effect():
	Events.draw_card.emit(draw_amount)
