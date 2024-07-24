class_name ElixerCardUI
extends CardUI

@onready var drop_point: DropPoint = $DropPoint
@onready var v_box_container: VBoxContainer = $Panel/VBoxContainer

const PROGRESS_COMPONENT : PackedScene = preload("res://scenes/ui/progress_component.tscn")

func _set_card(value: Card) -> void:
	super._set_card(value)
	if not is_node_ready():
		await ready
	if v_box_container.get_child_count() > 0: return
	for ingredient in value.ingredients:
		var new_progress_component = PROGRESS_COMPONENT.instantiate() as ProgressComponent
		v_box_container.add_child(new_progress_component)
		new_progress_component.ingredient = ingredient 
		drop_point.update_ingredients.connect(new_progress_component.update_ingredients)
		

func _ready() -> void:
	super._ready()
	drop_point.completed.connect(_on_elixer_completed)
	
func _on_elixer_completed() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.2,1.2), .5)
	await tween.finished
	
	for effect in card.effects:
		if effect is EffectBase:
			var new_card_effect := CARD_EFFECT_POPPUP.instantiate() as CardEffectPoppup
			new_card_effect.global_position = effect_spawn_location.global_position
			get_tree().current_scene.add_child(new_card_effect)
			if Events.reverse_elixir == 0:
				effect.apply_effect(char_stats)
				new_card_effect.start(effect)
			else:
				var block_effect = EffectBase.new()
				block_effect.description = "No Effect"
				new_card_effect.start(block_effect)
			await new_card_effect.complete
	if Events.reverse_elixir > 0:
		Events.reverse_elixir -= 1	
	Events.elixer_completed.emit()
	queue_free()
