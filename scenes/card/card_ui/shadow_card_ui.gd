class_name ShadowCardUI
extends CardUI

func play() -> void:
	if not card: return
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.2,1.2), .5)
	await tween.finished
	for effect in card.effects:
		if effect is EffectBase:
			var new_card_effect := CARD_EFFECT_POPPUP.instantiate() as CardEffectPoppup
			new_card_effect.global_position = effect_spawn_location.global_position
			get_tree().current_scene.add_child(new_card_effect)
			if Events.block_shadow == 0:
				effect.apply_effect(char_stats)
				new_card_effect.start(effect)
			else:
				var block_effect = EffectBase.new()
				block_effect.description = "No Effect"
				new_card_effect.start(block_effect)
			await new_card_effect.complete
	if Events.block_shadow > 0:
		Events.block_shadow -= 1
	card_played.emit()
	queue_free()
