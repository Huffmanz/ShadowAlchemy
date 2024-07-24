class_name MenuCardUI
extends CardUI

func _on_drop_point_detector_area_entered(area: Area2D):
	if area is MenuDropPoint:
		target = area

func _set_playable(value: bool) -> void:
	playable = true

func play() -> void:
	target.trigger()
