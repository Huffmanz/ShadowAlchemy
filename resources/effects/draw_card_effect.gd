class_name DrawEffect
extends EffectBase

@export var amount := 1

func apply_effect(char_stats: CharacterStats):
	var draw_amount = amount if amount > 0 else char_stats.hand_size_before_discard
	description = "+%s Cards" % [draw_amount]
	Events.draw_card.emit(draw_amount)
	await Events.player_hand_drawn
