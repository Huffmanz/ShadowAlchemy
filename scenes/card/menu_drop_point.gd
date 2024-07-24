class_name MenuDropPoint
extends Area2D

signal card_dropped

func trigger():
	card_dropped.emit()

