extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await ready
	card_ui.original_index = card_ui.get_index()
	card_ui.drop_point_detector.monitoring = true
	
func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
