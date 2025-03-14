extends CharacterBody2D

@export var animation_tree : AnimationTree

var input_direction
var playback : AnimationNodeStateMachinePlayback

func _ready() -> void:
	playback = animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	select_animation()
	update_anim_params()

func get_input():
	input_direction = Input.get_vector("left","right","up","down")
	velocity = input_direction * 300

func select_animation():
	if velocity == Vector2.ZERO:
		playback.travel("Idle")
	else:
		playback.travel("Walk")

func update_anim_params():
	if input_direction == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = input_direction
	animation_tree["parameters/Walk/blend_position"] = input_direction
