class_name ReschuffleDiscardDeck
extends EffectBase

@export var amount := 1

func apply_effect(char_stats: CharacterStats):
	var rescuffle_amount := amount if amount > 0 else char_stats.discard.cards.size()
	description = "+%s Cards to deck" % [rescuffle_amount]
	Events.reschuffle_discard_deck.emit(rescuffle_amount)
