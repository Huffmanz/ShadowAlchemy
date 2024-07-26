class_name Player
extends Node2D

@export var stats: CharacterStats : set = set_character_stats

func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		
	update_player()

func update_player():
	if not stats is CharacterStats: return
	if not is_inside_tree():
		await ready
	update_stats()
	
func update_stats():
	pass
