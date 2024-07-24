extends Effect

@export var amount := 1

func apply_effect():
	Events.discard_card.emit(amount)
