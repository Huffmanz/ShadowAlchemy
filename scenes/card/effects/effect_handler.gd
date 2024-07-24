class_name EffectHandler
extends Node

signal effects_applied

var effects : Array[Effect] = []

func _ready() -> void:
	for child in get_children():
		if child is Effect:
			effects.append(child)
			
	
func apply_effects() -> void:
	for effect in effects:
		effect.apply_effect()
		
	effects_applied.emit()

