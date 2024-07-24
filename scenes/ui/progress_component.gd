class_name ProgressComponent
extends Control

@export var ingredient : Cost : set = _set_ingredient
@export var ingredient_progress: Cost

@onready var ingredient_name: Label = %"ingredient name"
@onready var quantity: Label = %quantity

func _set_ingredient(value: Cost):
	ingredient = value
	ingredient_progress = Cost.new()
	ingredient_progress.card = ingredient.card
	ingredient_progress.count = 0
	update_ui()

func update_ingredients(value : Cost):
	if value.card.id == ingredient.card.id:
		ingredient_progress = value
		update_ui()
	
func update_ui() -> void:
	if not ingredient: return
	ingredient_name.text = ingredient.card.id
	quantity.text = "%s/%s" % [ingredient_progress.count, ingredient.count]
	if ingredient_progress.count == ingredient.count:
		ingredient_name.add_theme_color_override("font_color", Color.SEA_GREEN)
		quantity.add_theme_color_override("font_color", Color.SEA_GREEN)

