class_name MatchUI
extends CanvasLayer

@export var char_stats : CharacterStats : set = _set_char_stats

@onready var active_elixers: Hand = $ActiveElixers as Hand
@onready var hand: Hand = $Hand as Hand
@onready var shadow_hand: Hand = $ShadowHand
@onready var hud: CanvasLayer = $Hud

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	hand.char_stats = char_stats
	active_elixers.char_stats = char_stats
	shadow_hand.char_stats = char_stats
	hud.char_stats = char_stats
	

