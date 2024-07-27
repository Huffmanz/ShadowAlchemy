class_name Match
extends Node2D

@export var char_stats: CharacterStats
@export var player_handler: PlayerHandler

@onready var match_ui: MatchUI = %MatchUI as MatchUI
@onready var player: Player = $Player as Player
@onready var elixer_handler: Node2D = $ElixerHandler as ElixerHandler
@onready var shadow_handler: ShadowHandler = $ShadowHandler as ShadowHandler
@onready var shaker: Shaker = $Shaker as Shaker


const END_SCREEN = preload("res://scenes/levels/end_screen.tscn")
func _ready() -> void:
	var new_stats: CharacterStats = char_stats.create_instance()
	match_ui.char_stats = new_stats
	player.stats = new_stats
	Events.player_end_turn.connect(player_handler.end_turn)
	Events.shadow_turn_ended.connect(player_handler.start_turn)
	Events.player_turn_ended.connect(shadow_handler.start_turn)
	Events.game_over.connect(game_over)
	Events.victory.connect(victory)
	Events.effect_applied.connect(_on_effect_applied)
	start_match(new_stats)
	
func start_match(stats: CharacterStats) -> void:
	elixer_handler.start_battle(stats)
	await Events.elixers_drawn
	player_handler.start_battle(stats)
	
func game_over():
	var end_screen_instance = END_SCREEN.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	
func victory():
	var end_screen_instance = END_SCREEN.instantiate()
	add_child(end_screen_instance)
	
func _on_effect_applied(effect: EffectBase):
	shaker.start(.25)
