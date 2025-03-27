extends CharacterBody2D

@export var animation_tree : AnimationTree
const FLOATING_TEXT = preload("res://Scenes/UI/BriefFloatingText.tscn")
var input_direction
var playback : AnimationNodeStateMachinePlayback
var brief_floating_text_ref

func _ready() -> void:
	playback = animation_tree["parameters/playback"]

func _physics_process(_delta: float) -> void:
	get_input()
	update_anim_params()

func get_input():
	if Global.INTERACTING:
		playback.travel("Idle")
	else:
		input_direction = Input.get_vector("left","right","up","down")
		velocity = input_direction * 300
		
		# Select Animation
		if velocity == Vector2.ZERO:
			playback.travel("Idle")
		else:
			playback.travel("Walk")
		
		move_and_slide()

func update_anim_params():
	if input_direction == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = input_direction
	animation_tree["parameters/Walk/blend_position"] = input_direction

func show_floating_text(text: String):
	brief_floating_text_ref = FLOATING_TEXT.instantiate().with_data(text)
	self.add_child(brief_floating_text_ref)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	self.remove_child(brief_floating_text_ref)
