class_name DiscardEffect
extends EffectBase

@export var amount := 1

func apply_effect(char_stats: CharacterStats):
	var discard_amount = amount if amount > 0 else char_stats.hand.cards.size()
	char_stats.hand_size_before_discard = char_stats.hand.cards.size()
	description = "-%s Cards" % [discard_amount]
	Events.discard_card.emit(discard_amount)
