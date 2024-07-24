class_name GainManaEffect
extends EffectBase

@export var amount := 1

func apply_effect(char_stats: CharacterStats):
	Events.gain_mana.emit(amount)
