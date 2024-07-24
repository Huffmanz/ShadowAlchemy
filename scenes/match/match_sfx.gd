extends Node

@onready var draw_audio_player: RandomStreamPlayer = $draw_audio_player as RandomStreamPlayer
@onready var play_audio_player: RandomStreamPlayer = $play_audio_player

func _ready() -> void:
	Events.card_drawn.connect(_on_card_drawn)
	Events.card_played.connect(_on_card_played)
	
func _on_card_drawn():
	if draw_audio_player.playing:
		draw_audio_player.stop()
	draw_audio_player.play_random()
	
func _on_card_played(card: Card):
	if play_audio_player.playing:
		play_audio_player.stop()
	play_audio_player.play_random()
