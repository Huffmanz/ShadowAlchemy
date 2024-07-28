extends CanvasLayer
@onready var next_button: SoundButton = %NextButton
@onready var welcome: VBoxContainer = %Welcome
@onready var decks: VBoxContainer = %Decks
@onready var draw: VBoxContainer = %Draw
@onready var shadow: VBoxContainer = %Shadow
@onready var shadow_turn: VBoxContainer = %Shadow_Turn
@onready var player_turn_2: VBoxContainer = %Player_Turn_2
@onready var skip_tutorial: SoundButton = %SkipTutorial

var current_item: CanvasItem
var draws := 0
var deck_count := 0
var cards_played := 0

func _ready() -> void:
	Events.match_started.connect(_on_match_started)
	Events.player_turn_ended.connect(_on_player_turn_ended)
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	Events.shadow_turn_ended.connect(_on_shadow_turn_ended)
	Events.card_played.connect(_on_card_played)
	skip_tutorial.pressed.connect(_on_skip_tutorial_pressed)
	next_button.pressed.connect(_on_next_button_pressed)
	
	
func _on_match_started() -> void:
	current_item = welcome
	Events.disable_end_turn.emit(true)
	activate_item()
	
func _on_player_hand_drawn() -> void:
	Events.disable_end_turn.emit(true)
	draws += 1
	if draws == 1:
		current_item = decks.get_child(deck_count) as CanvasItem
		deck_count +=1 
		activate_item()
	if draws == 3:
		current_item = shadow
		activate_item()
		Events.disable_end_turn.emit(false)
	
func _on_card_played(card: Card):
	Events.disable_end_turn.emit(true)
	cards_played += 1
	if cards_played == 2:
		current_item = draw
		activate_item()
	
func _on_player_turn_ended() -> void:
	Events.disable_end_turn.emit(true)
	Events.disable_end_turn.emit(true)
	current_item = shadow_turn
	activate_item()
	
func _on_shadow_turn_ended() -> void:
	Events.disable_end_turn.emit(true)
	current_item = player_turn_2
	activate_item()
	
func activate_item():
	Events.disable_end_turn.emit(true)
	visible = true
	Events.tooltip_hide_requested.emit()
	current_item.visible = true
	get_tree().paused = true
	
func _on_next_button_pressed() -> void:
	if current_item:
		current_item.visible = false
		
	if deck_count > 0 and deck_count < decks.get_child_count():
		current_item = decks.get_child(deck_count) as CanvasItem
		deck_count +=1 
		activate_item()
	else:
		get_tree().paused = false
		visible = false
		
func _on_skip_tutorial_pressed():
	Events.skip_tutorial = true
	ScreenTransition.transition_to_scene("res://scenes/levels/match_scene.tscn")
	
	
