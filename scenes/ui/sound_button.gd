class_name SoundButton
extends Button

@onready var random_stream_player = $RandomStreamPlayer

func _ready():
	pressed.connect(on_pressed)
	
func on_pressed():
	random_stream_player.play_random()
