class_name BlockShadowEffect
extends EffectBase

@export var amount := 1

func apply_effect(char_stats: CharacterStats):
	Events.block_shadow += amount
