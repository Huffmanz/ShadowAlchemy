class_name Hand
extends BoxContainer

signal all_cards_played

@export var char_stats: CharacterStats
@export var card_ui : PackedScene

const  PLAY_INTERVAL := 0.5

func add_card_ui(new_card_ui: CardUI):
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.parent = self

func add_card(card: Card) -> void:
	var new_card_ui = card_ui.instantiate() as CardUI
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.char_stats = char_stats
	
func discard_card(card: Card) -> void:
	for card_ui in get_children():
		if card_ui is CardUI and card_ui.card.id == card.id and not card_ui.destroying:
			card_ui.destroy()
			break
	
func enable_hand() -> void:
	for card in get_children():
		if card is CardUI:
			card.disabled = false
	
func disable_hand() -> void:
	for card in get_children():
		if card is CardUI:
			card.disabled = true

func play_all() -> void:
	if get_child_count() == 0:
		await get_tree().create_timer(0.25).timeout
		all_cards_played.emit()
		return
	Events.tooltip_hide_requested.emit()
	for card in get_children():
		if card is CardUI:
			card.play()
			await card.card_played
	Events.tooltip_hide_requested.emit()
	all_cards_played.emit()
	
func _on_card_ui_reparent_requested(child: CardUI):
	child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.original_index, 0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
