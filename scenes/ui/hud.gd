extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats
@export var draw_effects: Array[EffectBase]
@onready var mana_label: Label = %ManaLabel
@onready var draw_card_button: Button = %DrawCardButton
@onready var deck_count_label: Label = %DeckCountLabel
@onready var end_turn_button: Button = %EndTurnButton
@onready var elixir_count_label: Label = %ElixirCountLabel
@onready var mana_shaker: Shaker = %mana_shaker
@onready var effect_spawn_location: Marker2D = $PanelContainer/EffectSpawnLocation

const CARD_EFFECT_POPPUP = preload("res://scenes/ui/card_effect_poppup.tscn")
var elixir_count = 0

func _ready():
	end_turn_button.disabled = true
	draw_card_button.disabled = true
	draw_card_button.pressed.connect(_on_draw_card_pressed)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	Events.elixer_completed.connect(_on_elixir_completed)
	mana_label.pivot_offset = mana_label.size  / 2

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
	#Events.draw_card.emit(1)
	#char_stats.mana -= 1
	for effect in draw_effects:
		effect.apply_effect(char_stats)
		var effect_poppup = CARD_EFFECT_POPPUP.instantiate() as CardEffectPoppup
		get_tree().current_scene.add_child(effect_poppup)
		effect_poppup.global_position = effect_spawn_location.global_position
		effect_poppup.start(effect)
		await effect_poppup.complete
	
func _on_end_turn_pressed():
	Events.player_end_turn.emit()
	end_turn_button.disabled = true
	draw_card_button.disabled = true
		
func _on_stats_changed():
	if not char_stats.draw_pile.card_pile_size_changed.is_connected(_on_draw_pile_changed):
		char_stats.draw_pile.card_pile_size_changed.connect(_on_draw_pile_changed)
		_on_draw_pile_changed(char_stats.draw_pile.cards.size())
	mana_label.text = "%s/%s" % [char_stats.mana, char_stats.max_mana]
	if char_stats.mana == 0:
		mana_label.label_settings.font_color = Color.RED
	else:
		mana_label.label_settings.font_color = Color.WHITE
	mana_shaker.start(.25)
	disabled_draw_button()

func update_elixir_display():
	elixir_count_label.text = "%s/%s" % [elixir_count, char_stats.elixer_deck.cards.size()]

func _on_elixir_completed():
	elixir_count += 1
	update_elixir_display()

func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false
	disabled_draw_button()

func _on_draw_pile_changed(count: int):
	disabled_draw_button()
	deck_count_label.text = "%s/%s" % [count, char_stats.starting_deck.cards.size()]
	
func disabled_draw_button():
	draw_card_button.disabled = char_stats.mana == 0 || char_stats.draw_pile.is_empty() || char_stats.hand.cards.size() >= char_stats.max_hand_size

