extends CanvasLayer

@onready var start_button: SoundButton = %StartButton
@onready var quit_button: SoundButton = %QuitButton

@onready var start_game_detector: MenuDropPoint = %StartGameDetector as MenuDropPoint
@onready var quit_game_detector: MenuDropPoint = %QuitGameDetector as MenuDropPoint

@onready var hand: Hand = $Hand
#@onready var card_ui: MenuCardUI = $Hand/CardUI
@onready var start_panel: PanelContainer = %StartPanel
@onready var quit_panel: PanelContainer = %QuitPanel
const MENU_CARD_UI = preload("res://scenes/card/card_ui/menu_card_ui.tscn")
var first := true

func _ready() -> void:
	start_button.pressed.connect(_start_button_clicked)
	quit_button.pressed.connect(get_tree().quit)
	start_game_detector.card_dropped.connect(_start_button_clicked)
	quit_game_detector.card_dropped.connect(get_tree().quit)
	start_panel.gui_input.connect(on_start_panel_input)
	quit_panel.gui_input.connect(on_quit_panel_input)


func _process(delta: float) -> void:
	if first:
		first = false
		await get_tree().create_timer(1.0).timeout
		var card_ui = MENU_CARD_UI.instantiate()
		hand.add_card_ui(card_ui)
		
func on_start_panel_input(event: InputEvent):
	if event.is_action_pressed("left_mouse"):
		_start_button_clicked()
		
func on_quit_panel_input(event: InputEvent):
	if event.is_action_pressed("left_mouse"):
		get_tree().quit()
		
func _start_button_clicked() -> void:
	if Events.skip_tutorial:
		ScreenTransition.transition_to_scene("res://scenes/levels/match_scene.tscn")
	else:
		ScreenTransition.transition_to_scene("res://scenes/levels/tutorial_scene.tscn")
