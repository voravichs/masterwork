extends Node2D
class_name BriefFloatingText

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

var text_display : String

func with_data(text: String) -> BriefFloatingText:
	# Get the first line in the starting dialogue
	text_display = text
	return self

func _ready() -> void:
	label.text = text_display
	self.visible = true
	animation_player.play("float_disappear")
