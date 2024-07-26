class_name  PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.5
const HAND_DISCARD_INTERVAL := 0.5

@export var hand: Hand
@onready var shadow_hand: Hand = %ShadowHand

var character: CharacterStats
var skip_draws : int = 0 : set = _set_skip_draws

func _set_skip_draws(value: int):
	skip_draws = clamp(value, 0, value)

func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	Events.draw_card.connect(draw_cards)
	Events.discard_card.connect(discard_cards)
	Events.gain_mana.connect(func(amount: int): character.mana += amount)
	Events.lose_mana.connect(func(amount: int): character.mana -= amount)
	Events.skip_draw_phase.connect(func(amount: int): skip_draws += amount)
	Events.reschuffle_discard_deck.connect(reshuffle_deck_from_discard)

func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.starting_deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	character.reset_mana()
	draw_cards(character.starting_hand_amount)
	start_turn()
	
func start_turn() -> void:
	if character.draw_pile.cards.is_empty():
		Events.game_over.emit()
	if skip_draws == 0:
		draw_cards(character.cards_per_turn)
	else:
		skip_draws -= 1
		draw_finished()
	hand.enable_hand()
	
func end_turn() -> void:
	character.reset_mana()
	hand.disable_hand()
	Events.player_turn_ended.emit()
	
func discard_cards(amount: int) -> void:
	var count := 0
	for i in range(amount):
		if not character.hand.cards.size() > 0: 
			break
		var card = character.hand.cards.pick_random()
		character.hand.remove_card(card)
		character.discard.add_card(card)
		hand.discard_card(card)
	Events.player_hand_discarded.emit()

func draw_card() -> void:
	var new_card = character.draw_pile.draw_card()
	if not new_card: return
	Events.card_drawn.emit()
	if new_card.type == Card.Type.Ingredient:
		hand.add_card(new_card)
		character.hand.add_card(new_card)
		hand.disable_hand()
	else:
		shadow_hand.add_card(new_card)
	
func reshuffle_deck_from_discard(amount: int) -> void:
	for i in range(amount + 1):
		if character.discard.is_empty():
			return
		character.draw_pile.add_card(character.discard.draw_card())
	character.draw_pile.shuffle()
		
func draw_cards(amount: int) -> void:
	var remaining_to_draw :=  character.max_hand_size - character.hand.cards.size()
	amount = clamp(amount, 0, remaining_to_draw)
	if amount == 0: return
	
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)	
	tween.finished.connect(draw_finished)
	
func draw_finished() -> void:
	hand.enable_hand()
	Events.player_hand_drawn.emit()
	
func _on_card_played(card: Card) -> void:
	character.discard.add_card(card)
	character.hand.remove_card(card)
