class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)
signal card_ready
signal card_played

@onready var panel: Panel = %Panel

const max_offset_shadow := 5.0

@export var card: Card : set = _set_card
@export var char_stats: CharacterStats : set = _set_char_stats

@onready var cost: Label = %Cost
@onready var icon: TextureRect = %Icon
@onready var name_text: Label = %Name
@onready var drop_point_detector: Area2D = $DropPointDetector

@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var target: Node
@onready var effect_spawn_location: Marker2D = $effect_spawn_location
@onready var shadow: Panel = %Shadow

@export_category("Oscillator")
@export var spring: float = 250.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0

const CARD_EFFECT_POPPUP = preload("res://scenes/ui/card_effect_poppup.tscn")

var original_index := 0
var parent: Control
var tween: Tween
var playable := true : set = _set_playable
var disabled := false
var is_card_ready := false
var tween_destroy: Tween

var last_mouse_pos: Vector2
var mouse_velocity: Vector2
var last_pos: Vector2
var velocity: Vector2
var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var destroying := false

func _set_playable(value: bool) -> void:
	playable = value
	if not playable and card.type != Card.Type.Elixer and card.type != Card.Type.Shadow:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1,1,1,0.5)
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1,1,1,1)

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)
	char_stats.can_play_card(card)

func _set_card(value: Card) -> void:
	if not value: 
		return
	if not is_node_ready():
		await ready
	card = value
	name_text.text = value.id
	if not card.cost and card.cost != 0:
		cost.text = str(card.cost)
	if card.icon:
		icon.texture = card.icon
	if not is_card_ready:
		card_ready.emit()
		is_card_ready = true

func _ready() -> void:
	material = material.duplicate(true)
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	card_state_machine.init(self)
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	drop_point_detector.area_entered.connect(_on_drop_point_detector_area_entered)
	drop_point_detector.area_exited.connect(_on_drop_point_detector_area_exited)
	
	
func _process(delta: float) -> void:
	rotate_velocity(delta)
	handle_shadow(delta)
	
func rotate_velocity(delta: float) -> void:
	var center_pos: Vector2 = global_position - (size/2.0)
	# Compute the velocity
	velocity = (position - last_pos) / delta
	last_pos = position
	
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	# Oscillator stuff
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	rotation = displacement
	
func handle_shadow(delta: float) -> void:
	var center : Vector2 = get_viewport_rect().size / 2.0
	var distance : float = global_position.x - center.x
	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance / (center.x)))
	
func _input(event):
	card_state_machine.on_input(event)
	
func _on_gui_input(event):
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	
func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	
func _on_drop_point_detector_area_entered(area: Area2D):
	if area is DropPoint:
		if (area as DropPoint).check_card(card):
			target = area
	
func _on_drop_point_detector_area_exited(area: Area2D):
	target = null
	
func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	disabled = true
	
func _on_card_drag_or_aim_ended(_card: CardUI) -> void:
	disabled = false
	self.playable = char_stats.can_play_card(card)
	
func _on_char_stats_changed() -> void:
	if not card or card.cost == 0: return
	self.playable = char_stats.can_play_card(card)
	
func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func play() -> void:
	if not card: return
	card.play(target, char_stats)
	card_played.emit()
	queue_free()
	
func destroy():
	destroying = true
	panel.use_parent_material = true
	cost.visible = false
	name_text.visible = false
	for child in panel.get_children():
		child.use_parent_material = true
	if tween_destroy and tween_destroy.is_running():
		tween_destroy.kill()
	tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_destroy.tween_property(material, "shader_parameter/dissolve_value", 0.0, 1.0).from(1.0)
	tween_destroy.parallel().tween_property(shadow, "self_modulate:a", 0.0, 1.0)
	card.destroyed.emit()
	await tween_destroy.finished
	queue_free()
