extends CardState

var played: bool

func enter() -> void:
	played = false
	
	if card_ui.target:
		Events.tooltip_hide_requested.emit()
		played = true
		card_ui.play()
		
func on_input(_event: InputEvent) -> void:
	if played: 
		return
		
	transition_requested.emit(self, CardState.State.BASE)
	
