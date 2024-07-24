class_name CharacterStats
extends Resource

signal stats_changed

@export var starting_deck: CardPile
@export var elixer_deck: CardPile
@export var max_hand_size: int
@export var starting_hand_amount: int
@export var cards_per_turn: int
@export var max_mana: int

var mana: int : set = set_mana
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile
var hand: CardPile
var hand_size_before_discard: int

func set_mana(value: int) -> void:
	mana = max(0, value)
	stats_changed.emit()
	
func reset_mana() -> void:
	mana = max_mana
	
func can_play_card(card: Card) -> bool:
	if not card or not card.cost or card.cost == 0: return false
	return mana >= card.cost

func create_instance() -> Resource:
	var instance : CharacterStats = self.duplicate()
	instance.reset_mana()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	instance.hand = CardPile.new()
	return instance
