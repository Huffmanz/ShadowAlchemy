class_name SoundButton
extends Button

@onready var random_stream_player = $RandomStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hover_stream_player: RandomStreamPlayer = $HoverStreamPlayer


func _ready():
	pressed.connect(on_pressed)
	mouse_entered.connect(on_mouse_entered)
	pivot_offset = size / 2
	
func on_pressed():
	random_stream_player.play_random()
	
func on_mouse_entered():
	if disabled == true:
		return
	animation_player.play("hover")
	hover_stream_player.play_random()
