extends CanvasLayer

@onready var panel_container: PanelContainer = %PanelContainer
@onready var restart_button: SoundButton = %Restart
@onready var quit_button: SoundButton = %QuitButton
@onready var title_label: RichTextLabel = %TitleLabel
@onready var description_label: RichTextLabel = %DescriptionLabel


func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	#get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
func set_defeat():
	title_label.text = "[center]Defeat![/center]"
	description_label.text = "[center]You Lost![/center]"
	
func set_tutorial():
	title_label.text = "[center]Tutorial Complete[/center]"
	description_label.text = "[center]Click next to start game[/center]"
	restart_button.text = "Next Level"
	
func on_restart_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/levels/match_scene.tscn")
	
func on_quit_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/levels/main_menu.tscn")
