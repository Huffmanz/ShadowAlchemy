class_name ReverseElixir
extends EffectBase

@export var amount := 1

func apply_effect(char_stats: CharacterStats):
	Events.reverse_elixir += amount
