extends Node

#game events
signal game_over
signal victory

#card events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested
signal card_drawn

#player related events
signal player_hand_drawn
signal player_hand_discarded
signal player_end_turn
signal player_turn_ended

#effects
signal draw_card(amount: int)
signal discard_card(amount: int)
signal gain_mana(amount: int)
signal lose_mana(amount: int)
signal skip_draw_phase(amount: int)
signal reschuffle_discard_deck(amount: int)
signal effect_applied(effect: EffectBase)

var reverse_elixir := 0 : set = _set_reverse_elixir
func _set_reverse_elixir(value: int):
	reverse_elixir = max(0, value)
	
var block_shadow := 0 : set = _set_block_shadow
func _set_block_shadow(value: int):
	block_shadow = max( 0, value)

signal elixers_drawn
signal elixer_completed

#shadow
signal shadow_turn_ended
