class_name LossManaEffect
extends EffectBase

@export var amount := 1

func apply_effect(char_stats: CharacterStats):
	Events.lose_mana.emit(amount)
