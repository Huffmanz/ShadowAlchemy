extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats
@onready var mana_label: Label = %ManaLabel
@onready var draw_card_button: Button = %DrawCardButton
@onready var deck_count_label: Label = %DeckCountLabel
@onready var end_turn_button: Button = %EndTurnButton
@onready var elixir_count_label: Label = %ElixirCountLabel
var elixir_count = 0

func _ready():
	draw_card_button.pressed.connect(_on_draw_card_pressed)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	Events.elixer_completed.connect(_on_elixir_completed)

func _set_char_stats(value: CharacterStats):
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)
		
	if not char_stats.draw_pile.card_pile_size_changed.is_connected(_on_draw_pile_changed):
		char_stats.draw_pile.card_pile_size_changed.connect(_on_draw_pile_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()
	_on_draw_pile_changed(char_stats.draw_pile.cards.size())
	update_elixir_display()
	
func _on_draw_card_pressed():
	if char_stats.mana == 0: return
	Events.draw_card.emit(1)
	char_stats.mana -= 1
	
func _on_end_turn_pressed():
	Events.player_end_turn.emit()
	end_turn_button.disabled = true
	draw_card_button.disabled = true
		
func _on_stats_changed():
	if not char_stats.draw_pile.card_pile_size_changed.is_connected(_on_draw_pile_changed):
		char_stats.draw_pile.card_pile_size_changed.connect(_on_draw_pile_changed)
		_on_draw_pile_changed(char_stats.draw_pile.cards.size())
	mana_label.text = "%s/%s" % [char_stats.mana, char_stats.max_mana]
	draw_card_button.disabled = char_stats.mana == 0 || char_stats.draw_pile.is_empty()

func update_elixir_display():
	elixir_count_label.text = "%s/%s" % [elixir_count, char_stats.elixer_deck.cards.size()]

func _on_elixir_completed():
	elixir_count += 1
	update_elixir_display()

func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false
	draw_card_button.disabled = false

func _on_draw_pile_changed(count: int):
	draw_card_button.disabled = char_stats.mana == 0 || char_stats.draw_pile.is_empty()
	deck_count_label.text = "%s/%s" % [count, char_stats.starting_deck.cards.size()]

