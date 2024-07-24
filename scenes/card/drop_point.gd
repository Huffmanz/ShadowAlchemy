class_name DropPoint
extends Area2D

signal completed
signal update_ingredients(cost: Cost)

@export var card_ui: CardUI

var card : Elixer
var ingredients: Array[Cost] = []
var current_ingredients : Array[Cost] = []

func _ready() -> void:
	card_ui.card_ready.connect(_on_card_ready)

func _on_card_ready():
	if card_ui.card is Elixer:
		card = card_ui.card
		ingredients = card.ingredients
	
func check_card(card_to_check: Card) -> bool:
	return needs_ingredient(card_to_check)

func add_ingredients(card: Card) -> void:
	for i in range(current_ingredients.size()):
		if current_ingredients[i].card.id == card.id:
			var count = current_ingredients[i].count 
			current_ingredients[i].count += 1
			update_ingredients.emit(current_ingredients[i])
			return
	var cost = Cost.new()
	cost.card = card
	cost.count = 1
	current_ingredients.append(cost)
	update_ingredients.emit(cost)
	
	if is_completed():
		completed.emit()
	
func needs_ingredient(card: Card) -> bool:
	var has_ingredient: bool = false
	var amount_needed: int = 0
	for i in range(ingredients.size()):
		if ingredients[i].card.id == card.id:
			has_ingredient = true
			amount_needed = ingredients[i].count
	
	if !has_ingredient:
		return has_ingredient	
	#needs ingredient, now check if it is already completed
	for i in range(current_ingredients.size()):
		if current_ingredients[i].card.id == card.id:
			amount_needed -= current_ingredients[i].count
	
	return amount_needed > 0
	
func is_completed() -> bool:
	for i in range(ingredients.size()):
		var count = ingredients[i].count
		for j in range(current_ingredients.size()):
			if ingredients[i].card.id == current_ingredients[j].card.id:
				count -= current_ingredients[j].count
		if count != 0:
			return false		
	return true

