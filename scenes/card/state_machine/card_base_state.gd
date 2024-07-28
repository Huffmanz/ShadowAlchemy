extends CardState

@export var hover_audio_player: RandomStreamPlayer

var tween_hover: Tween
var tween_rot: Tween

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
		
	card_ui.reparent_requested.emit(card_ui)
	Events.tooltip_hide_requested.emit()
	
func exit() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
		
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(card_ui, "scale",Vector2.ONE, .55)

func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return
		
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
	
func on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	hover_audio_player.play_random()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(card_ui, "scale",Vector2(1.2,1.2), .5)
	Events.card_tooltip_requested.emit(card_ui.card)
	
func on_mouse_exited() -> void:
	if not is_inside_tree():
		return
			
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
		
	tween_hover = create_tween()
	
	if tween_hover:
		tween_hover.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween_hover.tween_property(card_ui, "scale",Vector2.ONE, .55)
		
	Events.tooltip_hide_requested.emit()
