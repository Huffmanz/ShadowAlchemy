class_name ShadowHandler
extends Node2D

@export var shadow_hand: Hand

func start_turn() -> void:
	await get_tree().create_timer(2.0).timeout
	shadow_hand.play_all()
	await shadow_hand.all_cards_played
	end_turn()
	
func end_turn() -> void:
	await get_tree().create_timer(1.0).timeout
	Events.shadow_turn_ended.emit()
