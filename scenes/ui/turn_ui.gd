extends CanvasLayer

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var timer: Timer = %Timer

func _ready() -> void:
	Events.player_turn_ended.connect(_on_player_turn_ended)
	Events.shadow_turn_ended.connect(_on_shadow_turn_ended)
	timer.timeout.connect(func(): visible = false)
	timer.start()
	_on_shadow_turn_ended()
	
func _on_player_turn_ended():
	rich_text_label.text = "[wave][center]Apply Shadow Effects[/center][/wave]"
	visible = true
	timer.start()
	
func _on_shadow_turn_ended():
	rich_text_label.text = "[wave][center]Player Turn[/center][/wave]"
	visible = true
	timer.start()
