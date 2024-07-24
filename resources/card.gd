class_name Card
extends Resource

signal destroyed

enum Type { Ingredient, Elixer, Shadow }

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var cost: int
@export var effects : Array[EffectBase] = []

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
@export_multiline var effect_text: String

func initialize() -> void:
	pass

func play(target: Node, char_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	apply_effects(target)
	
func apply_effects(_target: Node) -> void:
	if _target is DropPoint:
		_target.add_ingredients(self)

