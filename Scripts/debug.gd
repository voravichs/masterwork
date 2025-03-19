extends Node2D

@onready var root: Node2D = $"."
var dialog_ui_reference: DialogUI

const DIALOGUE_FILE = "res://Dialogues/test_dialogue.dialogue"
const DIALOG_UI = preload("res://Scenes/UI/dialog_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Init a debug DialogUI
	var debug_dialogue_resource = load(DIALOGUE_FILE)
	dialog_ui_reference = DIALOG_UI.instantiate().with_data(debug_dialogue_resource, "start")
	root.add_child(dialog_ui_reference)
	dialog_ui_reference.finished_dialogue.connect(_show_gameplay_ui)

func _show_gameplay_ui():
	print("pogchamp :D")
	root.remove_child(dialog_ui_reference)
