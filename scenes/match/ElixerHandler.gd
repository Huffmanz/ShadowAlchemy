class_name ElixerHandler
extends Node2D

const HAND_DRAW_INTERVAL := 0.5
const HAND_DISCARD_INTERVAL := 0.5

@export var elixer_deck: CardPile
@export var elixers_to_draw := 3
@onready var active_elixers: Hand = %ActiveElixers as Hand
var elixir_count = 0

func _ready() -> void:
	Events.elixer_completed.connect(_on_elixer_completed)

func start_battle(char_stats: CharacterStats) -> void:
	elixer_deck = char_stats.elixer_deck.duplicate(true)
	elixer_deck.cards.shuffle()
	draw_cards(elixers_to_draw)
	await Events.elixers_drawn
	
func draw_card() -> void:
	var new_card = elixer_deck.draw_card()
	if new_card:
		active_elixers.add_card(new_card)
		elixir_count += 1
		Events.card_drawn.emit()

func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
		
	tween.finished.connect(
		func(): Events.elixers_drawn.emit()
	)
	
func _on_elixer_completed() -> void:
	elixir_count -= 1
	if(elixer_deck.cards.is_empty() and elixir_count == 0):
		Events.victory.emit()
		return
	await get_tree().create_timer(2.0).timeout
	draw_cards(1)
