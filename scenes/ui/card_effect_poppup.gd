class_name CardEffectPoppup
extends Control

signal complete

@onready var effect_label: RichTextLabel = %EffectLabel
@onready var timer: Timer = $Timer
@onready var effect_player: RandomStreamPlayer = $effect_player

func _ready() -> void:
	timer.timeout.connect(queue_free)
	
func start(effect: EffectBase):
	effect_label.text = "[shake rate=20.0 level=5 connected-1]%s[/shake]" % effect.description
	Events.effect_applied.emit(effect)
	effect_player.play_random()
	timer.start()
	await timer.timeout
	complete.emit()
	
