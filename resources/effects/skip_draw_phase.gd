class_name SkipDrawPhase
extends EffectBase

@export var amount := 1

func apply_effect(char_stats: CharacterStats):
	Events.skip_draw_phase.emit(amount)
