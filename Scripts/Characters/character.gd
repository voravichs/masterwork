extends CharacterBody2D

@export var animation_tree : AnimationTree
const FLOATING_TEXT : PackedScene = preload("res://Scenes/UI/BriefFloatingText.tscn")
const NORMAL_SPEED : int = 250
const RUN_SPEED : int = 400
var input_direction : Vector2
var playback : AnimationNodeStateMachinePlayback
var brief_floating_text_ref : BriefFloatingText
var isometric_scale : Vector2 = Vector2(1, 0.5)

func _ready() -> void:
	playback = animation_tree["parameters/playback"]

func _physics_process(_delta: float) -> void:
	get_input()
	update_anim_params()

func get_input() -> void:
	if Global.OCCUPIED:
		playback.travel("Idle")
	else:
		# Inputs
		input_direction = Input.get_vector("left","right","up","down")
		var is_running : bool = Input.is_action_pressed("run")
		
		# Diagonal normalized
		if input_direction != Vector2.ZERO:
			input_direction = Vector2(input_direction.x, input_direction.y * isometric_scale.y).normalized()
		
		# Running check and set velocity
		var speed : int = RUN_SPEED if is_running else NORMAL_SPEED
		velocity = input_direction * speed
		
		# Select Animation
		if velocity == Vector2.ZERO:
			playback.travel("Idle")
		else:
			playback.travel("Walk")
		
		move_and_slide()

func update_anim_params() -> void:
	if input_direction == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = input_direction
	animation_tree["parameters/Walk/blend_position"] = input_direction

func show_floating_text(text: String) -> void:
	brief_floating_text_ref = FLOATING_TEXT.instantiate().with_data(text)
	self.add_child(brief_floating_text_ref)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	self.remove_child(brief_floating_text_ref)
